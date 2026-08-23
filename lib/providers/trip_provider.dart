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

  List<TripModel> get trips => _trips;
  List<ActivityModel> get currentActivities => _currentActivities;
  bool get isLoading => _isLoading;

  Future<void> loadTrips() async {
    _isLoading = true;
    notifyListeners();
    _trips = await _dbHelper.getAllTrips();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> createTrip(String prompt, DateTime startDate) async {
    _isLoading = true;
    notifyListeners();

    // 1. Get parsed details from Gemini (Mock)
    final aiResult = await _aiService.parsePrompt(prompt);
    
    // 2. Create Trip record
    final trip = TripModel(
      id: _uuid.v4(),
      title: aiResult['title'],
      originalPrompt: prompt,
      startDate: startDate,
      endDate: startDate.add(Duration(days: aiResult['durationDays'] - 1)),
      createdAt: DateTime.now(),
      status: 'UPCOMING',
    );
    await _dbHelper.insertTrip(trip);
    
    // 3. Get activities from Amadeus (Mock)
    final activities = await _travelService.fetchActivitiesForTrip(
      trip.id,
      aiResult['durationDays'],
      startDate,
    );
    await _dbHelper.insertActivities(activities);

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

  Future<void> startTrip(String tripId) async {
    await _dbHelper.updateTripStatus(tripId, 'ACTIVE');
    await loadTrips();
  }
}
