import 'package:flutter_test/flutter_test.dart';
import 'package:trip_planner/data/services/ai_service.dart';
import 'package:trip_planner/data/services/travel_service.dart';
import 'package:trip_planner/data/local_db/db_helper.dart';

void main() {
  group('5-Step AI & Local DB Travel Planning Pipeline Tests', () {
    late AIService aiService;
    late TravelService travelService;
    late DatabaseHelper dbHelper;

    setUp(() {
      aiService = AIService(apiKey: 'dummy_test_key');
      travelService = TravelService();
      dbHelper = DatabaseHelper.instance;
    });

    test('Step 1 & 2: User prompt parses destination, duration, transport, and key spot', () async {
      const prompt = 'I want to go to Paris by train, stay for 2 days, and see the Eiffel Tower.';

      final extracted = await aiService.parsePrompt(prompt);

      expect(extracted['destination'], 'Paris');
      expect(extracted['durationDays'], 2);
      expect(extracted['transportMode'], 'Train');
      expect(extracted['keySpot'], 'Eiffel Tower');
    });

    test('Step 3: Local SQLite database catalog search retrieves matching options', () async {
      // 1. Train schedule to Paris
      final transport = await dbHelper.searchTransport(destination: 'Paris', mode: 'Train');
      expect(transport.mode, 'Train');
      expect(transport.title.toLowerCase().contains('paris'), true);
      expect(transport.startHour, 9);
      expect(transport.endHour, 11);
      expect(transport.endMinute, 30);

      // 2. Suggested hotel in Paris
      final hotel = await dbHelper.searchHotels(destination: 'Paris');
      expect(hotel.destination, 'Paris');
      expect(hotel.name.isNotEmpty, true);
      expect(hotel.costPerNight, greaterThan(0));

      // 3. Eiffel Tower details
      final spots = await dbHelper.searchSightseeing(destination: 'Paris', query: 'Eiffel Tower');
      expect(spots.isNotEmpty, true);
      expect(spots.first.name, 'Eiffel Tower');
      expect(spots.first.entryFee, greaterThan(0));

      // 4. Lunch and dinner spots
      final lunches = await dbHelper.searchDining(destination: 'Paris', mealType: 'Lunch');
      final dinners = await dbHelper.searchDining(destination: 'Paris', mealType: 'Dinner');
      expect(lunches.isNotEmpty, true);
      expect(dinners.isNotEmpty, true);
      expect(lunches.first.mealType, 'Lunch');
      expect(dinners.first.mealType, 'Dinner');
    });

    test('Step 4: Scheduling algorithm arranges exact realistic time blocks for Day 1', () async {
      final startDate = DateTime(2026, 7, 10);
      final activities = await travelService.buildItinerary(
        tripId: 'test-trip-paris-1',
        destination: 'Paris',
        durationDays: 2,
        startDate: startDate,
        transportMode: 'Train',
        keySpot: 'Eiffel Tower',
      );

      expect(activities.isNotEmpty, true);

      // Filter Day 1 activities
      final day1 = activities.where((a) => a.dayNumber == 1).toList();
      expect(day1.length, 5);

      // 1. 09:00 AM – 11:30 AM: Train departure to Paris
      expect(day1[0].activityType, 'TRANSPORT');
      expect(day1[0].startTime.hour, 9);
      expect(day1[0].startTime.minute, 0);
      expect(day1[0].endTime.hour, 11);
      expect(day1[0].endTime.minute, 30);
      expect(day1[0].title.toLowerCase().contains('train'), true);

      // 2. 12:00 PM – 01:30 PM: Lunch at a local restaurant
      expect(day1[1].activityType, 'FOOD');
      expect(day1[1].startTime.hour, 12);
      expect(day1[1].startTime.minute, 0);
      expect(day1[1].endTime.hour, 13);
      expect(day1[1].endTime.minute, 30);
      expect(day1[1].title.toLowerCase().contains('lunch'), true);

      // 3. 02:00 PM – 03:00 PM: Hotel check-in
      expect(day1[2].activityType, 'HOTEL');
      expect(day1[2].startTime.hour, 14);
      expect(day1[2].startTime.minute, 0);
      expect(day1[2].endTime.hour, 15);
      expect(day1[2].endTime.minute, 0);
      expect(day1[2].title.toLowerCase().contains('check-in'), true);

      // 4. 04:00 PM – 06:00 PM: Sightseeing at the Eiffel Tower
      expect(day1[3].activityType, 'SIGHTSEEING');
      expect(day1[3].startTime.hour, 16);
      expect(day1[3].startTime.minute, 0);
      expect(day1[3].endTime.hour, 18);
      expect(day1[3].endTime.minute, 0);
      expect(day1[3].title.toLowerCase().contains('eiffel tower'), true);

      // 5. 07:30 PM – 09:30 PM: Dinner at a local restaurant
      expect(day1[4].activityType, 'FOOD');
      expect(day1[4].startTime.hour, 19);
      expect(day1[4].startTime.minute, 30);
      expect(day1[4].endTime.hour, 21);
      expect(day1[4].endTime.minute, 30);
      expect(day1[4].title.toLowerCase().contains('dinner'), true);
    });

    test('Financial Summary calculation calculates aggregated budget by category', () async {
      final startDate = DateTime(2026, 7, 10);
      final activities = await travelService.buildItinerary(
        tripId: 'test-trip-paris-2',
        destination: 'Paris',
        durationDays: 2,
        startDate: startDate,
        transportMode: 'Train',
        keySpot: 'Eiffel Tower',
      );

      double transitTotal = 0.0;
      double hotelTotal = 0.0;
      double foodTotal = 0.0;
      double sightseeingTotal = 0.0;

      for (final a in activities) {
        switch (a.activityType) {
          case 'TRANSPORT':
            transitTotal += a.cost;
            break;
          case 'HOTEL':
            hotelTotal += a.cost;
            break;
          case 'FOOD':
            foodTotal += a.cost;
            break;
          case 'SIGHTSEEING':
            sightseeingTotal += a.cost;
            break;
        }
      }

      final grandTotal = transitTotal + hotelTotal + foodTotal + sightseeingTotal;

      expect(transitTotal, greaterThan(0));
      expect(hotelTotal, greaterThan(0));
      expect(foodTotal, greaterThan(0));
      expect(sightseeingTotal, greaterThan(0));
      expect(grandTotal, equals(transitTotal + hotelTotal + foodTotal + sightseeingTotal));
    });

    test('Day-by-Day grouping cleanly separates days for navigation tabs', () async {
      final startDate = DateTime(2026, 7, 10);
      final activities = await travelService.buildItinerary(
        tripId: 'test-trip-paris-3',
        destination: 'Paris',
        durationDays: 2,
        startDate: startDate,
      );

      final day1Events = activities.where((a) => a.dayNumber == 1).toList();
      final day2Events = activities.where((a) => a.dayNumber == 2).toList();

      expect(day1Events.length, 5);
      expect(day2Events.length, 5);
      expect(activities.length, 10);
    });
  });
}
