import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:trip_planner/data/local_db/db_helper.dart';
import 'package:trip_planner/data/models/trip_model.dart';
import 'package:trip_planner/data/models/activity_model.dart';
import 'package:trip_planner/data/models/user_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SQLite DatabaseHelper Tests', () {
    late DatabaseHelper db;

    setUp(() async {
      DatabaseHelper.customDatabasePath = inMemoryDatabasePath;
      await DatabaseHelper.instance.close();
      db = DatabaseHelper.instance;
    });

    test('SQLite initializes and pre-seeds default user and catalog', () async {
      final user = await db.authenticateUser('traveler@example.com', 'password123');
      expect(user, isNotNull);
      expect(user!.name, 'Alex Morgan');

      // Test catalog query from SQLite
      final transport = await db.searchTransport(destination: 'Paris', mode: 'Train');
      expect(transport.destination, 'Paris');
      expect(transport.mode, 'Train');

      final hotel = await db.searchHotels(destination: 'Paris');
      expect(hotel.destination, 'Paris');

      final spots = await db.searchSightseeing(destination: 'Paris');
      expect(spots.isNotEmpty, true);

      final lunch = await db.searchDining(destination: 'Paris', mealType: 'Lunch');
      expect(lunch.isNotEmpty, true);
    });

    test('SQLite user registration, authentication and password reset', () async {
      final newUser = UserModel(
        id: 'u-sqlite-1',
        name: 'SQLite Traveler',
        email: 'sqlite.traveler@example.com',
        createdAt: DateTime.now(),
      );

      final registered = await db.registerUser(newUser, 'secret123');
      expect(registered, true);

      // Duplicate registration fails
      final duplicate = await db.registerUser(newUser, 'secret123');
      expect(duplicate, false);

      // Authenticate
      final authUser = await db.authenticateUser('sqlite.traveler@example.com', 'secret123');
      expect(authUser, isNotNull);
      expect(authUser!.email, 'sqlite.traveler@example.com');

      // Reset password
      final reset = await db.resetPassword('sqlite.traveler@example.com', 'newSecret456');
      expect(reset, true);

      // Old password fails
      final oldAuth = await db.authenticateUser('sqlite.traveler@example.com', 'secret123');
      expect(oldAuth, isNull);

      // New password succeeds
      final newAuth = await db.authenticateUser('sqlite.traveler@example.com', 'newSecret456');
      expect(newAuth, isNotNull);
    });

    test('SQLite trip and activity CRUD operations', () async {
      final trip = TripModel(
        id: 'trip-sqlite-101',
        title: 'SQLite Paris Journey',
        originalPrompt: 'Plan a 3-day Paris trip',
        destinationName: 'Paris',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 2)),
        createdAt: DateTime.now(),
        status: 'UPCOMING',
      );

      await db.insertTrip(trip);
      final trips = await db.getAllTrips();
      expect(trips.any((t) => t.id == 'trip-sqlite-101'), true);

      // Update status
      await db.updateTripStatus('trip-sqlite-101', 'ACTIVE');
      final updatedTrips = await db.getAllTrips();
      final updated = updatedTrips.firstWhere((t) => t.id == 'trip-sqlite-101');
      expect(updated.status, 'ACTIVE');

      // Insert activities
      final activity = ActivityModel(
        id: 'act-sqlite-1',
        tripId: 'trip-sqlite-101',
        dayNumber: 1,
        activityType: 'TRANSPORT',
        title: 'Eurostar Express',
        description: 'High-speed rail to Paris',
        startTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(hours: 2)),
        cost: 4500.0,
      );

      await db.insertActivities([activity]);
      final activities = await db.getActivitiesForTrip('trip-sqlite-101');
      expect(activities.length, 1);
      expect(activities.first.title, 'Eurostar Express');
      expect(activities.first.isCompleted, false);

      // Toggle completion
      await db.toggleActivityCompletion('act-sqlite-1');
      final toggledActs = await db.getActivitiesForTrip('trip-sqlite-101');
      expect(toggledActs.first.isCompleted, true);

      // Delete trip
      await db.deleteTrip('trip-sqlite-101');
      final afterDeleteTrips = await db.getAllTrips();
      expect(afterDeleteTrips.any((t) => t.id == 'trip-sqlite-101'), false);
      final afterDeleteActs = await db.getActivitiesForTrip('trip-sqlite-101');
      expect(afterDeleteActs.isEmpty, true);
    });
  });
}
