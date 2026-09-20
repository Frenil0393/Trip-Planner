import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
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
  AIExecutionResult? _lastExecutionResult;

  List<TripModel> get trips => _trips;
  List<ActivityModel> get currentActivities => _currentActivities;
  bool get isLoading => _isLoading;
  String get statusMessage => _statusMessage;
  AIExecutionResult? get lastExecutionResult => _lastExecutionResult;
  String get currentApiKey => _aiService.apiKey;

  void updateApiKey(String newKey) {
    _aiService.updateApiKey(newKey.trim());
    notifyListeners();
  }

  Future<Map<String, dynamic>> testGeminiConnection() async {
    return await _aiService.testConnection();
  }

  Future<void> loadTrips() async {
    _isLoading = true;
    notifyListeners();
    _trips = await _dbHelper.getAllTrips();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> createTrip(String prompt, DateTime startDate) async {
    _isLoading = true;
    _statusMessage = 'Sending prompt to Google Gemini LLM...';
    notifyListeners();

    // Step 1 & 2: LLM extracts clean parameters & captures raw JSON response
    final execution = await _aiService.parsePromptWithDetails(prompt);
    _lastExecutionResult = execution;

    _statusMessage = 'Parsing LLM JSON response & scheduling itinerary...';
    notifyListeners();

    final aiResult = execution.parsedData;
    final durationDays = (aiResult['durationDays'] as num?)?.toInt() ?? 2;
    final destination = (aiResult['destination'] as String?)?.isNotEmpty == true
        ? aiResult['destination'] as String
        : 'Paris';
    final transportMode = aiResult['transportMode'] as String? ?? 'Train';
    final keySpot = aiResult['keySpot'] as String?;

    // Create Trip record with LLM telemetry attached
    final trip = TripModel(
      id: _uuid.v4(),
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

    // Step 3 & 4: Search local SQLite database and generate chronological timeline
    final activities = await _travelService.buildItinerary(
      tripId: trip.id,
      destination: destination,
      durationDays: durationDays,
      startDate: startDate,
      transportMode: transportMode,
      keySpot: keySpot,
    );

    await _dbHelper.insertActivities(activities);
    _statusMessage = '';
    await loadTrips();
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
