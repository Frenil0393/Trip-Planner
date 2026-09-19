import '../models/trip_model.dart';
import '../models/activity_model.dart';
import '../models/user_model.dart';
import 'travel_catalog.dart';

class DatabaseHelper {
  // In-memory data store for trips, activities, and authenticated users
  final List<TripModel> _trips = [];
  final List<ActivityModel> _activities = [];

  // In-memory user credentials store: email -> { 'user': UserModel, 'password': password }
  final Map<String, Map<String, dynamic>> _users = {
    'traveler@example.com': {
      'user': UserModel(
        id: 'default-traveler-id',
        name: 'Alex Morgan',
        email: 'traveler@example.com',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      'password': 'password123',
    }
  };

  static final DatabaseHelper instance = DatabaseHelper._init();

  DatabaseHelper._init();

  // --------------------------------------------------------------------------
  // User Authentication
  // --------------------------------------------------------------------------

  /// Registers a new user account. Returns false if the email already exists.
  Future<bool> registerUser(UserModel user, String password) async {
    final emailKey = user.email.trim().toLowerCase();
    if (_users.containsKey(emailKey)) {
      return false;
    }
    _users[emailKey] = {
      'user': user,
      'password': password,
    };
    return true;
  }

  /// Verifies credentials and returns the [UserModel] if valid, otherwise null.
  Future<UserModel?> authenticateUser(String email, String password) async {
    final emailKey = email.trim().toLowerCase();
    final entry = _users[emailKey];
    if (entry != null && entry['password'] == password) {
      return entry['user'] as UserModel;
    }
    return null;
  }

  /// Fetches user by email address.
  Future<UserModel?> getUserByEmail(String email) async {
    final emailKey = email.trim().toLowerCase();
    final entry = _users[emailKey];
    return entry != null ? (entry['user'] as UserModel) : null;
  }

  /// Resets a user's password.
  Future<bool> resetPassword(String email, String newPassword) async {
    final emailKey = email.trim().toLowerCase();
    final entry = _users[emailKey];
    if (entry != null) {
      entry['password'] = newPassword;
      return true;
    }
    return false;
  }

  // --------------------------------------------------------------------------
  // Trips
  // --------------------------------------------------------------------------

  Future<void> insertTrip(TripModel trip) async {
    _trips.add(trip);
  }

  Future<List<TripModel>> getAllTrips() async {
    return List.from(_trips);
  }

  Future<void> updateTripStatus(String tripId, String newStatus) async {
    final index = _trips.indexWhere((t) => t.id == tripId);
    if (index != -1) {
      _trips[index].status = newStatus;
    }
  }

  Future<void> deleteTrip(String tripId) async {
    _trips.removeWhere((t) => t.id == tripId);
    _activities.removeWhere((a) => a.tripId == tripId);
  }

  // --------------------------------------------------------------------------
  // Activities Management
  // --------------------------------------------------------------------------

  Future<void> insertActivities(List<ActivityModel> activities) async {
    _activities.addAll(activities);
  }

  Future<List<ActivityModel>> getActivitiesForTrip(String tripId) async {
    return _activities.where((a) => a.tripId == tripId).toList();
  }

  Future<void> toggleActivityCompletion(String activityId) async {
    final index = _activities.indexWhere((a) => a.id == activityId);
    if (index != -1) {
      final old = _activities[index];
      _activities[index] = old.copyWith(isCompleted: !old.isCompleted);
    }
  }

  // --------------------------------------------------------------------------
  // Step 3: Local Database Travel Catalog Queries
  // --------------------------------------------------------------------------

  /// Searches matching transport schedules for the destination and mode (e.g. Train, Flight).
  Future<CatalogTransport> searchTransport({
    required String destination,
    String? mode,
  }) async {
    final destLower = destination.trim().toLowerCase();
    final modeLower = mode?.trim().toLowerCase() ?? 'train';

    final matches = TravelCatalog.transports.where((t) {
      final matchesDest = t.destination.toLowerCase().contains(destLower) ||
          destLower.contains(t.destination.toLowerCase());
      final matchesMode = t.mode.toLowerCase().contains(modeLower) ||
          modeLower.contains(t.mode.toLowerCase());
      return matchesDest && matchesMode;
    }).toList();

    if (matches.isNotEmpty) return matches.first;

    // Try destination-only match
    final destOnly = TravelCatalog.transports.where((t) {
      return t.destination.toLowerCase().contains(destLower) ||
          destLower.contains(t.destination.toLowerCase());
    }).toList();

    if (destOnly.isNotEmpty) return destOnly.first;

    // Generic fallback transport
    final isTrain = modeLower.contains('train') || modeLower.contains('rail');
    return CatalogTransport(
      id: 'trans-custom-default',
      destination: destination,
      mode: isTrain ? 'Train' : 'Flight',
      title: isTrain ? 'Train to $destination (Express Line)' : 'Flight to $destination',
      description: 'Scheduled transit departure to $destination with reserved seating.',
      cost: isTrain ? 65.0 : 140.0,
      startHour: 9,
      startMinute: 0,
      endHour: 11,
      endMinute: 30,
    );
  }

  /// Searches suggested hotels in destination.
  Future<CatalogHotel> searchHotels({required String destination}) async {
    final destLower = destination.trim().toLowerCase();
    final matches = TravelCatalog.hotels.where((h) {
      return h.destination.toLowerCase().contains(destLower) ||
          destLower.contains(h.destination.toLowerCase());
    }).toList();

    if (matches.isNotEmpty) return matches.first;

    // Fallback hotel
    return CatalogHotel(
      id: 'hotel-custom-default',
      destination: destination,
      name: 'Grand $destination Boutique Hotel',
      description: 'Central modern accommodation with breakfast and comfortable amenities.',
      costPerNight: 150.0,
      checkInHour: 14,
      checkInMinute: 0,
    );
  }

  /// Searches sightseeing spots matching destination and optional query/key spot keyword.
  Future<List<CatalogSpot>> searchSightseeing({
    required String destination,
    String? query,
  }) async {
    final destLower = destination.trim().toLowerCase();
    final qLower = query?.trim().toLowerCase();

    final destSpots = TravelCatalog.spots.where((s) {
      return s.destination.toLowerCase().contains(destLower) ||
          destLower.contains(s.destination.toLowerCase());
    }).toList();

    if (destSpots.isEmpty) {
      // Return custom fallback spots
      final spotTitle = (query != null && query.isNotEmpty)
          ? query
          : '$destination City Highlights Tour';
      return [
        CatalogSpot(
          id: 'spot-custom-1',
          destination: destination,
          name: spotTitle,
          description: 'Explore historical landmarks, scenic architecture, and top viewpoints in $destination.',
          entryFee: 25.0,
          durationMinutes: 120,
        ),
        CatalogSpot(
          id: 'spot-custom-2',
          destination: destination,
          name: '$destination Cultural Heritage Stroll',
          description: 'Discover the rich history, art galleries, and vibrant public squares of $destination.',
          entryFee: 15.0,
          durationMinutes: 90,
        ),
      ];
    }

    if (qLower != null && qLower.isNotEmpty) {
      // Sort so matching spot comes first
      destSpots.sort((a, b) {
        final aMatch = a.name.toLowerCase().contains(qLower) ||
            a.keywords.any((k) => qLower.contains(k) || k.contains(qLower));
        final bMatch = b.name.toLowerCase().contains(qLower) ||
            b.keywords.any((k) => qLower.contains(k) || k.contains(qLower));
        if (aMatch && !bMatch) return -1;
        if (!aMatch && bMatch) return 1;
        return 0;
      });
    }

    return destSpots;
  }

  /// Searches dining recommendations (Lunch / Dinner) in destination.
  Future<List<CatalogDining>> searchDining({
    required String destination,
    String? mealType,
  }) async {
    final destLower = destination.trim().toLowerCase();
    final mLower = mealType?.trim().toLowerCase();

    var matches = TravelCatalog.dinings.where((d) {
      final matchDest = d.destination.toLowerCase().contains(destLower) ||
          destLower.contains(d.destination.toLowerCase());
      if (mLower != null && mLower.isNotEmpty) {
        return matchDest && d.mealType.toLowerCase() == mLower;
      }
      return matchDest;
    }).toList();

    if (matches.isNotEmpty) return matches;

    // Fallback dining
    final isDinner = mLower == 'dinner';
    return [
      CatalogDining(
        id: 'dine-custom-${isDinner ? 'dinner' : 'lunch'}',
        destination: destination,
        mealType: isDinner ? 'Dinner' : 'Lunch',
        restaurantName: isDinner
            ? 'La Trattoria del $destination'
            : 'Le Central Café & Bistro',
        description: isDinner
            ? 'Signature evening dinner featuring chef specials and regional delicacies.'
            : 'Casual dining offering fresh local specialties and seasonal dishes.',
        averageCost: isDinner ? 45.0 : 25.0,
      )
    ];
  }
}

