import '../models/activity_model.dart';
import 'package:uuid/uuid.dart';

class TravelService {
  final _uuid = const Uuid();

  /// Simulates fetching activities from Amadeus based on trip details.
  Future<List<ActivityModel>> fetchActivitiesForTrip(String tripId, int durationDays, DateTime startDate) async {
    await Future.delayed(const Duration(seconds: 2));
    List<ActivityModel> activities = [];
    
    for (int day = 1; day <= durationDays; day++) {
      final currentDay = startDate.add(Duration(days: day - 1));
      
      activities.addAll([
        ActivityModel(
          id: _uuid.v4(),
          tripId: tripId,
          dayNumber: day,
          activityType: 'HOTEL',
          title: 'Luxury Stay',
          description: 'Relax at a 5-star hotel.',
          startTime: DateTime(currentDay.year, currentDay.month, currentDay.day, 14, 0),
          endTime: DateTime(currentDay.year, currentDay.month, currentDay.day, 23, 59),
          cost: 250.0,
        ),
        ActivityModel(
          id: _uuid.v4(),
          tripId: tripId,
          dayNumber: day,
          activityType: 'SIGHTSEEING',
          title: 'City Tour',
          description: 'Explore the main attractions.',
          startTime: DateTime(currentDay.year, currentDay.month, currentDay.day, 9, 0),
          endTime: DateTime(currentDay.year, currentDay.month, currentDay.day, 13, 0),
          cost: 50.0,
        ),
      ]);
    }
    
    return activities;
  }
}
