import 'package:flutter_test/flutter_test.dart';
import 'package:trip_planner/data/models/models.dart';

void main() {
  group('DestinationModel Tests', () {
    test('Instantiation and sample destinations lookup', () {
      expect(DestinationModel.sampleDestinations.length, greaterThanOrEqualTo(4));

      final paris = DestinationModel.findByName('Paris');
      expect(paris.name, 'Paris');
      expect(paris.country, 'France');
      expect(paris.spots.isNotEmpty, true);
      expect(paris.dining.isNotEmpty, true);

      final tokyo = DestinationModel.findByName('tokyo');
      expect(tokyo.name, 'Tokyo');
      expect(tokyo.currency, 'JPY');

      // Fallback lookup
      final custom = DestinationModel.findByName('Reykjavik');
      expect(custom.name, 'Reykjavik');
    });

    test('toMap and fromMap round-trip serialization', () {
      final original = DestinationModel(
        id: 'dest-101',
        name: 'Barcelona',
        country: 'Spain',
        tagline: 'Sun, sea, and Gaudi.',
        description: 'Vibrant Mediterranean city.',
        imageUrl: 'https://example.com/bcn.jpg',
        rating: 4.8,
        tags: const ['Art', 'Beach'],
        bestTimeToVisit: 'May - June',
        currency: 'EUR',
        spots: const [
          DestinationSpot(
            id: 'spot-1',
            title: 'Sagrada Familia',
            description: 'Unfinished Gaudi masterpiece.',
            imageUrl: 'https://example.com/sagrada.jpg',
            category: 'Basilica',
            rating: 4.9,
          ),
        ],
        dining: const [
          DestinationDining(
            id: 'dine-1',
            title: 'Tapas 24',
            description: 'Gourmet tapas bar.',
            imageUrl: 'https://example.com/tapas.jpg',
            cuisine: 'Spanish Tapas',
            priceRange: '\$\$',
            rating: 4.6,
          ),
        ],
      );

      final map = original.toMap();
      final restored = DestinationModel.fromMap(map);

      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.country, original.country);
      expect(restored.tagline, original.tagline);
      expect(restored.tags, original.tags);
      expect(restored.spots.length, 1);
      expect(restored.spots.first.title, 'Sagrada Familia');
      expect(restored.dining.length, 1);
      expect(restored.dining.first.title, 'Tapas 24');
    });

    test('toJson and fromJson round-trip', () {
      final original = DestinationModel.sampleDestinations.first;
      final jsonStr = original.toJson();
      final restored = DestinationModel.fromJson(jsonStr);

      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.spots.length, original.spots.length);
    });

    test('copyWith updates fields correctly', () {
      const original = DestinationModel(
        id: 'dest-1',
        name: 'Original Name',
        country: 'Original Country',
        imageUrl: 'https://example.com/img.jpg',
      );

      final updated = original.copyWith(name: 'Updated Name', rating: 4.9);
      expect(updated.name, 'Updated Name');
      expect(updated.rating, 4.9);
      expect(updated.country, 'Original Country');
      expect(updated.id, 'dest-1');
    });
  });

  group('ActivityModel Tests', () {
    test('ActivityType enum parsing and helpers', () {
      expect(ActivityType.fromString('TRANSPORT'), ActivityType.transport);
      expect(ActivityType.fromString('flight'), ActivityType.transport);
      expect(ActivityType.fromString('HOTEL'), ActivityType.hotel);
      expect(ActivityType.fromString('SIGHTSEEING'), ActivityType.sightseeing);
      expect(ActivityType.fromString('FOOD'), ActivityType.food);
      expect(ActivityType.fromString('UNKNOWN'), ActivityType.other);

      expect(ActivityType.food.displayName, 'Dining');
      expect(ActivityType.hotel.toCode(), 'HOTEL');
    });

    test('ActivityModel duration and calculations', () {
      final start = DateTime(2026, 10, 10, 14, 0);
      final end = DateTime(2026, 10, 10, 16, 30);

      final activity = ActivityModel(
        id: 'act-1',
        tripId: 'trip-1',
        dayNumber: 1,
        activityType: 'TRANSPORT',
        title: 'Flight to Rome',
        description: 'Flight AZ123',
        startTime: start,
        endTime: end,
        cost: 150.0,
      );

      expect(activity.durationInMinutes, 150);
      expect(activity.formattedDuration, '2h 30m');
      expect(activity.isFree, false);
      expect(activity.typeEnum, ActivityType.transport);

      final freeActivity = activity.copyWith(cost: 0.0);
      expect(freeActivity.isFree, true);
    });

    test('toMap and fromMap round-trip', () {
      final start = DateTime(2026, 5, 1, 10, 0);
      final end = DateTime(2026, 5, 1, 12, 0);

      final original = ActivityModel(
        id: 'act-123',
        tripId: 'trip-456',
        dayNumber: 2,
        activityType: 'SIGHTSEEING',
        title: 'Colosseum Guided Tour',
        description: 'Explore ancient arena',
        startTime: start,
        endTime: end,
        cost: 45.0,
        location: 'Piazza del Colosseo',
        isCompleted: true,
      );

      final map = original.toMap();
      expect(map['is_completed'], 1);

      final restored = ActivityModel.fromMap(map);
      expect(restored.id, original.id);
      expect(restored.tripId, original.tripId);
      expect(restored.dayNumber, 2);
      expect(restored.activityType, 'SIGHTSEEING');
      expect(restored.cost, 45.0);
      expect(restored.location, 'Piazza del Colosseo');
      expect(restored.isCompleted, true);
    });
  });

  group('TripModel Tests', () {
    test('TripStatus enum parsing and transitions', () {
      expect(TripStatus.fromString('UPCOMING'), TripStatus.upcoming);
      expect(TripStatus.fromString('ACTIVE'), TripStatus.active);
      expect(TripStatus.fromString('PAST'), TripStatus.past);
      expect(TripStatus.fromString('COMPLETED'), TripStatus.past);

      final trip = TripModel(
        id: 't-1',
        title: 'Paris Summer Trip',
        originalPrompt: '3 days in Paris',
        startDate: DateTime(2026, 7, 1),
        endDate: DateTime(2026, 7, 3),
        createdAt: DateTime(2026, 6, 1),
        status: 'UPCOMING',
      );

      expect(trip.isUpcoming, true);
      expect(trip.isActive, false);

      trip.setStatusFromEnum(TripStatus.active);
      expect(trip.isActive, true);
      expect(trip.status, 'ACTIVE');
    });

    test('TripModel durationInDays calculation', () {
      final trip = TripModel(
        id: 't-2',
        title: 'Weekend Escape',
        originalPrompt: 'Weekend trip',
        startDate: DateTime(2026, 8, 10),
        endDate: DateTime(2026, 8, 12),
        createdAt: DateTime(2026, 8, 1),
      );

      // Aug 10, 11, 12 = 3 days
      expect(trip.durationInDays, 3);
    });

    test('TripModel toMap and fromMap round-trip', () {
      final original = TripModel(
        id: 'trip-99',
        title: 'Tokyo Explorer',
        originalPrompt: '5 days in Tokyo for anime and gadgets',
        destinationId: 'tokyo',
        destinationName: 'Tokyo',
        startDate: DateTime(2026, 9, 1),
        endDate: DateTime(2026, 9, 5),
        createdAt: DateTime(2026, 8, 20),
        status: 'UPCOMING',
        estimatedBudget: 1500.0,
        coverImageUrl: 'https://example.com/tokyo.jpg',
      );

      final map = original.toMap();
      final restored = TripModel.fromMap(map);

      expect(restored.id, original.id);
      expect(restored.title, original.title);
      expect(restored.originalPrompt, original.originalPrompt);
      expect(restored.destinationId, 'tokyo');
      expect(restored.destinationName, 'Tokyo');
      expect(restored.status, 'UPCOMING');
      expect(restored.estimatedBudget, 1500.0);
      expect(restored.coverImageUrl, 'https://example.com/tokyo.jpg');
      expect(restored.durationInDays, 5);
    });
  });
}
