import '../models/trip_model.dart';
import '../models/activity_model.dart';

class DatabaseHelper {
  // In-memory mock database
  final List<TripModel> _trips = [];
  final List<ActivityModel> _activities = [];

  static final DatabaseHelper instance = DatabaseHelper._init();

  DatabaseHelper._init();

  Future<void> insertTrip(TripModel trip) async {
    _trips.add(trip);
  }

  Future<void> insertActivities(List<ActivityModel> activities) async {
    _activities.addAll(activities);
  }

  Future<List<TripModel>> getAllTrips() async {
    return _trips;
  }

  Future<List<ActivityModel>> getActivitiesForTrip(String tripId) async {
    return _activities.where((a) => a.tripId == tripId).toList();
  }

  Future<void> updateTripStatus(String tripId, String newStatus) async {
    final index = _trips.indexWhere((t) => t.id == tripId);
    if (index != -1) {
      _trips[index].status = newStatus;
    }
  }
}
