import 'package:uuid/uuid.dart';
import '../models/activity_model.dart';
import '../local_db/db_helper.dart';

/// TravelService handles:
/// - Step 3: Searching the local SQLite database for matching transport schedules,
///   suggested hotels, sightseeing details, and dining options.
/// - Step 4: Arranging retrieved items into a realistic chronological schedule.
class TravelService {
  final _uuid = const Uuid();
  final DatabaseHelper _db = DatabaseHelper.instance;

  /// Generates a realistic chronological itinerary for a trip using local DB catalog.
  Future<List<ActivityModel>> buildItinerary({
    required String tripId,
    required String destination,
    required int durationDays,
    required DateTime startDate,
    String? transportMode,
    String? keySpot,
  }) async {
    // Step 3: Search local database for destination parameters
    final transport = await _db.searchTransport(
      destination: destination,
      mode: transportMode,
    );
    final hotel = await _db.searchHotels(destination: destination);
    final spots = await _db.searchSightseeing(
      destination: destination,
      query: keySpot,
    );
    final lunches = await _db.searchDining(
      destination: destination,
      mealType: 'Lunch',
    );
    final dinners = await _db.searchDining(
      destination: destination,
      mealType: 'Dinner',
    );

    final activities = <ActivityModel>[];
    int spotIdx = 0;
    int lunchIdx = 0;
    int dinnerIdx = 0;

    for (int day = 1; day <= durationDays; day++) {
      final currentDay = startDate.add(Duration(days: day - 1));

      if (day == 1) {
        // Step 4 Day 1: Strict realistic time blocks as specified:
        // 09:00 AM – 11:30 AM: Train/Transport departure to destination
        // 12:00 PM – 01:30 PM: Lunch at a local restaurant
        // 02:00 PM – 03:00 PM: Hotel check-in
        // 04:00 PM – 06:00 PM: Sightseeing at the Eiffel Tower (Key Spot)
        // 07:30 PM – 09:30 PM: Dinner at a local restaurant

        final lunch = lunches[lunchIdx % lunches.length];
        lunchIdx++;

        final primarySpot = spots.isNotEmpty ? spots[0] : null;
        spotIdx++;

        final dinner = dinners[dinnerIdx % dinners.length];
        dinnerIdx++;

        activities.addAll([
          // 09:00 AM – 11:30 AM: TRANSPORT
          ActivityModel(
            id: _uuid.v4(),
            tripId: tripId,
            dayNumber: 1,
            activityType: 'TRANSPORT',
            title: transport.title,
            description: transport.description,
            startTime: DateTime(currentDay.year, currentDay.month, currentDay.day, 9, 0),
            endTime: DateTime(currentDay.year, currentDay.month, currentDay.day, 11, 30),
            cost: transport.cost,
            location: '$destination Central Station / Airport',
            imageUrl: 'assets/images/spot_default.jpg',
          ),
          // 12:00 PM – 01:30 PM: FOOD (Lunch)
          ActivityModel(
            id: _uuid.v4(),
            tripId: tripId,
            dayNumber: 1,
            activityType: 'FOOD',
            title: 'Lunch at ${lunch.restaurantName}',
            description: lunch.description,
            startTime: DateTime(currentDay.year, currentDay.month, currentDay.day, 12, 0),
            endTime: DateTime(currentDay.year, currentDay.month, currentDay.day, 13, 30),
            cost: lunch.averageCost,
            location: '$destination City Center',
            imageUrl: 'assets/images/spot_default.jpg',
            notes: 'Meal: Lunch',
          ),
          // 02:00 PM – 03:00 PM: HOTEL (Check-in)
          ActivityModel(
            id: _uuid.v4(),
            tripId: tripId,
            dayNumber: 1,
            activityType: 'HOTEL',
            title: '${hotel.name} Check-in',
            description: 'Check in, unpack, and freshen up. ${hotel.description}',
            startTime: DateTime(currentDay.year, currentDay.month, currentDay.day, 14, 0),
            endTime: DateTime(currentDay.year, currentDay.month, currentDay.day, 15, 0),
            cost: hotel.costPerNight,
            location: hotel.name,
            imageUrl: 'assets/images/spot_default.jpg',
            notes: 'Hotel Stay',
          ),
          // 04:00 PM – 06:00 PM: SIGHTSEEING (Key Spot)
          ActivityModel(
            id: _uuid.v4(),
            tripId: tripId,
            dayNumber: 1,
            activityType: 'SIGHTSEEING',
            title: primarySpot != null ? 'Sightseeing at ${primarySpot.name}' : '$destination Highlights',
            description: primarySpot != null ? primarySpot.description : 'Top points of interest and landmarks.',
            startTime: DateTime(currentDay.year, currentDay.month, currentDay.day, 16, 0),
            endTime: DateTime(currentDay.year, currentDay.month, currentDay.day, 18, 0),
            cost: primarySpot?.entryFee ?? 25.0,
            location: primarySpot?.name ?? destination,
            imageUrl: 'assets/images/spot_default.jpg',
            notes: 'Entry Fee: \$${(primarySpot?.entryFee ?? 25.0).toStringAsFixed(2)}',
          ),
          // 07:30 PM – 09:30 PM: FOOD (Dinner)
          ActivityModel(
            id: _uuid.v4(),
            tripId: tripId,
            dayNumber: 1,
            activityType: 'FOOD',
            title: 'Dinner at ${dinner.restaurantName}',
            description: dinner.description,
            startTime: DateTime(currentDay.year, currentDay.month, currentDay.day, 19, 30),
            endTime: DateTime(currentDay.year, currentDay.month, currentDay.day, 21, 30),
            cost: dinner.averageCost,
            location: dinner.restaurantName,
            imageUrl: 'assets/images/spot_default.jpg',
            notes: 'Meal: Dinner',
          ),
        ]);
      } else {
        // Subsequent Days: Morning breakfast, morning sight, lunch, afternoon sight, dinner
        final daySpot1 = spots.length > spotIdx ? spots[spotIdx++] : spots.first;
        final daySpot2 = spots.length > spotIdx ? spots[spotIdx++] : spots.last;
        final dayLunch = lunches[lunchIdx++ % lunches.length];
        final dayDinner = dinners[dinnerIdx++ % dinners.length];

        activities.addAll([
          // 08:30 AM – 10:00 AM: HOTEL / Breakfast
          ActivityModel(
            id: _uuid.v4(),
            tripId: tripId,
            dayNumber: day,
            activityType: 'HOTEL',
            title: 'Breakfast at ${hotel.name}',
            description: 'Continental artisan breakfast and preparation for the day.',
            startTime: DateTime(currentDay.year, currentDay.month, currentDay.day, 8, 30),
            endTime: DateTime(currentDay.year, currentDay.month, currentDay.day, 10, 0),
            cost: 20.0,
            location: hotel.name,
            imageUrl: 'assets/images/spot_default.jpg',
          ),
          // 10:30 AM – 01:00 PM: SIGHTSEEING
          ActivityModel(
            id: _uuid.v4(),
            tripId: tripId,
            dayNumber: day,
            activityType: 'SIGHTSEEING',
            title: 'Explore ${daySpot1.name}',
            description: daySpot1.description,
            startTime: DateTime(currentDay.year, currentDay.month, currentDay.day, 10, 30),
            endTime: DateTime(currentDay.year, currentDay.month, currentDay.day, 13, 0),
            cost: daySpot1.entryFee,
            location: daySpot1.name,
            imageUrl: 'assets/images/spot_default.jpg',
            notes: 'Entry Fee: \$${daySpot1.entryFee.toStringAsFixed(2)}',
          ),
          // 01:00 PM – 02:30 PM: FOOD (Lunch)
          ActivityModel(
            id: _uuid.v4(),
            tripId: tripId,
            dayNumber: day,
            activityType: 'FOOD',
            title: 'Lunch at ${dayLunch.restaurantName}',
            description: dayLunch.description,
            startTime: DateTime(currentDay.year, currentDay.month, currentDay.day, 13, 0),
            endTime: DateTime(currentDay.year, currentDay.month, currentDay.day, 14, 30),
            cost: dayLunch.averageCost,
            location: dayLunch.restaurantName,
            imageUrl: 'assets/images/spot_default.jpg',
            notes: 'Meal: Lunch',
          ),
          // 03:30 PM – 06:00 PM: SIGHTSEEING
          ActivityModel(
            id: _uuid.v4(),
            tripId: tripId,
            dayNumber: day,
            activityType: 'SIGHTSEEING',
            title: 'Visit ${daySpot2.name}',
            description: daySpot2.description,
            startTime: DateTime(currentDay.year, currentDay.month, currentDay.day, 15, 30),
            endTime: DateTime(currentDay.year, currentDay.month, currentDay.day, 18, 0),
            cost: daySpot2.entryFee,
            location: daySpot2.name,
            imageUrl: 'assets/images/spot_default.jpg',
            notes: 'Entry Fee: \$${daySpot2.entryFee.toStringAsFixed(2)}',
          ),
          // 07:30 PM – 09:30 PM: FOOD (Dinner)
          ActivityModel(
            id: _uuid.v4(),
            tripId: tripId,
            dayNumber: day,
            activityType: 'FOOD',
            title: 'Dinner at ${dayDinner.restaurantName}',
            description: dayDinner.description,
            startTime: DateTime(currentDay.year, currentDay.month, currentDay.day, 19, 30),
            endTime: DateTime(currentDay.year, currentDay.month, currentDay.day, 21, 30),
            cost: dayDinner.averageCost,
            location: dayDinner.restaurantName,
            imageUrl: 'assets/images/spot_default.jpg',
            notes: 'Meal: Dinner',
          ),
        ]);
      }
    }

    return activities;
  }

  /// Legacy/Compatibility method for existing callers.
  Future<List<ActivityModel>> fetchActivitiesForTrip(
    String tripId,
    int durationDays,
    DateTime startDate,
  ) async {
    return buildItinerary(
      tripId: tripId,
      destination: 'Paris',
      durationDays: durationDays,
      startDate: startDate,
    );
  }
}
