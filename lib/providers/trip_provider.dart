import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../data/local_db/travel_catalog.dart';
import '../data/models/trip_model.dart';
import '../data/models/activity_model.dart';
import '../data/services/ai_service.dart';
import '../data/services/travel_service.dart';
import '../data/local_db/db_helper.dart';

class TripProvider with ChangeNotifier {
  final _aiService = AIService();
  final _travelService = TravelService();
  final _dbHelper = DatabaseHelper.instance;
  final _uuid = const Uuid();

  List<TripModel> _trips = [];
  List<ActivityModel> _currentActivities = [];
  bool _isLoading = false;
  String _statusMessage = '';
  String? _errorMessage;
  AIExecutionResult? _lastExecutionResult;

  List<TripModel> get trips => _trips;
  List<ActivityModel> get currentActivities => _currentActivities;
  bool get isLoading => _isLoading;
  String get statusMessage => _statusMessage;
  String? get errorMessage => _errorMessage;
  AIExecutionResult? get lastExecutionResult => _lastExecutionResult;
  String get currentApiKey => _aiService.apiKey;

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  void updateApiKey(String newKey) {
    _aiService.updateApiKey(newKey.trim());
    notifyListeners();
  }

  Future<Map<String, dynamic>> testGeminiConnection() async {
    return await _aiService.testConnection();
  }

  Future<void> loadTrips({String? userId}) async {
    _isLoading = true;
    notifyListeners();
    try {
      _trips = await _dbHelper.getAllTrips(userId: userId);
    } catch (e) {
      debugPrint('[TripProvider] Error loading trips: $e');
      _trips = [];
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createTrip(String prompt, DateTime startDate, {int? defaultDurationDays, String? userId}) async {
    _isLoading = true;
    _errorMessage = null;
    _statusMessage = 'Sending prompt to Google Gemini LLM...';
    notifyListeners();

    try {
      // Step 1 & 2: LLM extracts clean parameters & captures raw JSON response
      final execution = await _aiService.parsePromptWithDetails(prompt);
      _lastExecutionResult = execution;

      final aiResult = execution.parsedData;
      if (aiResult.containsKey('error') && aiResult['error'] != null) {
        _isLoading = false;
        _statusMessage = '';
        _errorMessage = aiResult['error']?.toString() ?? 'Trip not found';
        notifyListeners();
        return false;
      }

      final rawDest = aiResult['destination'] as String?;
      if (rawDest == null || rawDest.trim().isEmpty) {
        _isLoading = false;
        _statusMessage = '';
        _errorMessage = 'Trip not found';
        notifyListeners();
        return false;
      }

      // Match destination in supported database catalog
      final destination = TravelCatalog.matchDestination(rawDest) ??
          (TravelCatalog.isSupported(rawDest) ? rawDest : null);

      if (destination == null || !TravelCatalog.isSupported(destination)) {
        _isLoading = false;
        _statusMessage = '';
        _errorMessage = 'Trip not found';
        notifyListeners();
        return false;
      }

      _statusMessage = 'Parsing LLM JSON response & scheduling itinerary...';
      notifyListeners();

      // Priority: Explicit prompt duration > AI response duration > UI selected defaultDurationDays > 3
      int durationDays = defaultDurationDays ?? 3;
      final promptDuration = AIService.extractDurationDays(prompt);
      if (promptDuration != null) {
        durationDays = promptDuration;
      } else {
        final rawDuration = aiResult['durationDays'];
        if (rawDuration is num) {
          durationDays = rawDuration.toInt();
        } else if (rawDuration is String) {
          durationDays = AIService.extractDurationDays(rawDuration) ?? durationDays;
        }
      }
      durationDays = durationDays.clamp(1, 7);
      final transportMode = aiResult['transportMode'] as String? ?? 'Train';
      final keySpot = aiResult['keySpot'] as String?;

      // Create Trip record with LLM telemetry attached and user isolation
      final trip = TripModel(
        id: _uuid.v4(),
        userId: userId,
        title: aiResult['title'] ?? '$destination $transportMode Trip',
        originalPrompt: prompt,
        destinationName: destination,
        startDate: startDate,
        endDate: startDate.add(Duration(days: durationDays - 1)),
        createdAt: DateTime.now(),
        status: 'UPCOMING',
        rawJsonResponse: execution.rawJsonResponse,
        llmModel: execution.modelUsed,
        isLiveAi: execution.isLiveApi,
        latencyMs: execution.latencyMs,
      );
      await _dbHelper.insertTrip(trip);

      // Step 3 & 4: Check if live Gemini AI generated activities, otherwise schedule from SQLite catalog
      List<ActivityModel> activities = [];
      if (execution.isLiveApi &&
          aiResult['activities'] is List &&
          (aiResult['activities'] as List).isNotEmpty) {
        try {
          final rawList = aiResult['activities'] as List;
          for (final rawItem in rawList) {
            if (rawItem is Map) {
              final dayNum = (rawItem['dayNumber'] as num?)?.toInt() ?? 1;
              final actDay = startDate.add(Duration(days: dayNum - 1));
              final startH = (rawItem['startHour'] as num?)?.toInt() ?? 9;
              final startM = (rawItem['startMinute'] as num?)?.toInt() ?? 0;
              final endH = (rawItem['endHour'] as num?)?.toInt() ?? (startH + 2);
              final endM = (rawItem['endMinute'] as num?)?.toInt() ?? 0;
              final costVal = (rawItem['cost'] as num?)?.toDouble() ?? 500.0;
              final actType =
                  (rawItem['activityType'] as String?)?.toUpperCase() ?? 'SIGHTSEEING';
              final actTitle =
                  rawItem['title']?.toString() ?? '$destination Activity';
              final actDesc = rawItem['description']?.toString() ??
                  'Scheduled activity in $destination.';

              activities.add(ActivityModel(
                id: _uuid.v4(),
                tripId: trip.id,
                dayNumber: dayNum,
                activityType: actType,
                title: actTitle,
                description: actDesc,
                startTime:
                    DateTime(actDay.year, actDay.month, actDay.day, startH, startM),
                endTime:
                    DateTime(actDay.year, actDay.month, actDay.day, endH, endM),
                cost: costVal,
                location: destination,
                imageUrl: 'assets/images/spot_default.jpg',
              ));
            }
          }
        } catch (_) {
          activities = [];
        }
      }

      if (activities.isEmpty) {
        activities = await _travelService.buildItinerary(
          tripId: trip.id,
          destination: destination,
          durationDays: durationDays,
          startDate: startDate,
          transportMode: transportMode,
          keySpot: keySpot,
        );
      }

      await _dbHelper.insertActivities(activities);
      _statusMessage = '';
      _errorMessage = null;
      await loadTrips(userId: userId);
      return true;
    } catch (e) {
      _isLoading = false;
      _statusMessage = '';
      _errorMessage = 'Trip not found';
      notifyListeners();
      return false;
    }
  }

  Future<void> loadActivitiesForTrip(String tripId) async {
    _isLoading = true;
    notifyListeners();
    _currentActivities = await _dbHelper.getActivitiesForTrip(tripId);
    // Sort by day and time
    _currentActivities.sort((a, b) {
      if (a.dayNumber != b.dayNumber) {
        return a.dayNumber.compareTo(b.dayNumber);
      }
      return a.startTime.compareTo(b.startTime);
    });
    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleActivityCompletion(String activityId, String tripId) async {
    await _dbHelper.toggleActivityCompletion(activityId);
    await loadActivitiesForTrip(tripId);
  }

  Future<void> startTrip(String tripId) async {
    await _dbHelper.updateTripStatus(tripId, 'ACTIVE');
    await loadTrips();
  }

  Future<void> completeTrip(String tripId) async {
    await _dbHelper.updateTripStatus(tripId, 'COMPLETED');
    await loadTrips();
  }

  Future<void> deleteTrip(String tripId) async {
    await _dbHelper.deleteTrip(tripId);
    await loadTrips();
  }
}
