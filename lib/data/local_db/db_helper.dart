import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as ffi;
import 'package:path/path.dart' as p;
import '../models/trip_model.dart';
import '../models/activity_model.dart';
import '../models/user_model.dart';
import 'travel_catalog.dart';
/// SQLite Database Helper managing local storage for:
/// - Authenticated users and credentials (`users` table)
/// - User active session tracking (`app_sessions` table)
/// - User planned trips (`trips` table with user isolation)
/// - Scheduled trip activities (`activities` table)
/// - Pre-seeded catalog schedules, hotels, spots, and dining (`catalog_*` tables)
///
/// Fully cross-platform: utilizes native/FFI SQLite on Desktop/Mobile/Tests,
/// with persistent localStorage fallback via SharedPreferences on Flutter Web.
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  static String? customDatabasePath;

  // Web localStorage persistence keys
  static const String _keyWebUsers = 'trip_planner_web_users_v2';
  static const String _keyWebActiveUser = 'trip_planner_web_active_user_v2';
  static const String _keyWebTrips = 'trip_planner_web_trips_v2';
  static const String _keyWebActivities = 'trip_planner_web_activities_v2';

  bool _webHydrated = false;

  // Web fallback store (persisted in browser localStorage across reloads)
  final List<TripModel> _webTrips = [];
  final List<ActivityModel> _webActivities = [];
  String? _webActiveUserId;
  final Map<String, Map<String, dynamic>> _webUsers = {
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

  /// Restores saved users, active session, trips, and activities from browser localStorage
  Future<void> _ensureWebHydrated() async {
    if (!kIsWeb || _webHydrated) return;
    try {
      final prefs = await SharedPreferences.getInstance();

      // 1. Hydrate active session
      final savedActiveUserId = prefs.getString(_keyWebActiveUser);
      if (savedActiveUserId != null && savedActiveUserId.isNotEmpty) {
        _webActiveUserId = savedActiveUserId;
      }

      // 2. Hydrate registered users
      final usersRaw = prefs.getString(_keyWebUsers);
      if (usersRaw != null && usersRaw.isNotEmpty) {
        final decoded = jsonDecode(usersRaw);
        if (decoded is Map) {
          for (final entry in decoded.entries) {
            final email = entry.key.toString().toLowerCase();
            final val = entry.value;
            if (val is Map) {
              final userMap = Map<String, dynamic>.from(val['user'] as Map);
              final pass = (val['password'] ?? '').toString();
              _webUsers[email] = {
                'user': UserModel.fromMap(userMap),
                'password': pass,
              };
            }
          }
        }
      }

      // 3. Hydrate trips
      final tripsRaw = prefs.getString(_keyWebTrips);
      if (tripsRaw != null && tripsRaw.isNotEmpty) {
        final decoded = jsonDecode(tripsRaw);
        if (decoded is List) {
          _webTrips.clear();
          for (final item in decoded) {
            if (item is Map) {
              _webTrips.add(TripModel.fromMap(Map<String, dynamic>.from(item)));
            }
          }
        }
      }

      // 4. Hydrate activities
      final actsRaw = prefs.getString(_keyWebActivities);
      if (actsRaw != null && actsRaw.isNotEmpty) {
        final decoded = jsonDecode(actsRaw);
        if (decoded is List) {
          _webActivities.clear();
          for (final item in decoded) {
            if (item is Map) {
              _webActivities.add(ActivityModel.fromMap(Map<String, dynamic>.from(item)));
            }
          }
        }
      }

      _webHydrated = true;
    } catch (e) {
      debugPrint('[DatabaseHelper] Error hydrating web storage: $e');
    }
  }

  /// Initializes database on Native/Desktop or hydrates from browser localStorage on Web.
  Future<void> init() async {
    if (kIsWeb) {
      await _ensureWebHydrated();
    } else {
      await database;
    }
  }

  Future<void> _persistWebUsers() async {
    if (!kIsWeb) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final mapToSave = <String, dynamic>{};
      for (final entry in _webUsers.entries) {
        final val = entry.value;
        UserModel? user;
        if (val['user'] is UserModel) {
          user = val['user'] as UserModel;
        } else if (val['user'] is Map) {
          user = UserModel.fromMap(Map<String, dynamic>.from(val['user'] as Map));
        }
        final pass = (val['password'] ?? '').toString();
        if (user != null) {
          mapToSave[entry.key] = {
            'user': user.toMap(),
            'password': pass,
          };
        }
      }
      await prefs.setString(_keyWebUsers, jsonEncode(mapToSave));
    } catch (e) {
      debugPrint('[DatabaseHelper] Error persisting web users: $e');
    }
  }

  Future<void> _persistWebSession(String? userId) async {
    if (!kIsWeb) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      if (userId == null || userId.isEmpty) {
        await prefs.remove(_keyWebActiveUser);
      } else {
        await prefs.setString(_keyWebActiveUser, userId);
      }
    } catch (e) {
      debugPrint('[DatabaseHelper] Error persisting web session: $e');
    }
  }

  Future<void> _persistWebTrips() async {
    if (!kIsWeb) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = _webTrips.map((t) => t.toMap()).toList();
      await prefs.setString(_keyWebTrips, jsonEncode(list));
    } catch (e) {
      debugPrint('[DatabaseHelper] Error persisting web trips: $e');
    }
  }

  Future<void> _persistWebActivities() async {
    if (!kIsWeb) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = _webActivities.map((a) => a.toMap()).toList();
      await prefs.setString(_keyWebActivities, jsonEncode(list));
    } catch (e) {
      debugPrint('[DatabaseHelper] Error persisting web activities: $e');
    }
  }

  DatabaseHelper._init();

  /// Gets the SQLite [Database] instance on native/desktop/tests.
  /// Returns `null` on Web to prevent browser databaseFactory crashes.
  Future<Database?> get database async {
    if (kIsWeb) return null;
    if (_database != null && _database!.isOpen) return _database!;
    _database = await _initDatabase();
    return _database;
  }

  /// Initializes sqflite FFI on desktop platforms (Windows, macOS, Linux).
  /// Initializes sqflite FFI on desktop platforms (Windows, macOS, Linux).
  void _initFfiIfNeeded() {
    if (kIsWeb) return;
    try {
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        ffi.sqfliteFfiInit();
        databaseFactory = ffi.databaseFactoryFfi;
      }
    } catch (_) {}
  }

  /// Opens or creates the SQLite database file on disk or custom path.
  Future<Database?> _initDatabase() async {
    if (kIsWeb) return null;
    _initFfiIfNeeded();

    String path;
    if (customDatabasePath != null) {
      path = customDatabasePath!;
    } else {
      final dbPath = await getDatabasesPath();
      path = p.join(dbPath, 'trip_planner.db');
    }

    return await openDatabase(
      path,
      version: 2,
      onConfigure: _onConfigure,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  /// Enables SQLite foreign key constraints safely across platforms.
  Future<void> _onConfigure(Database db) async {
    try {
      await db.execute('PRAGMA foreign_keys = ON');
    } catch (e) {
      debugPrint('[DatabaseHelper] onConfigure notice: $e');
    }
  }

  /// Creates SQLite tables and pre-seeds initial user and travel catalog.
  Future<void> _createDB(Database db, int version) async {
    // 1. Users Table
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        avatar_url TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    // 2. Active Session Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS app_sessions (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');

    // 3. Trips Table (with user isolation)
    await db.execute('''
      CREATE TABLE trips (
        id TEXT PRIMARY KEY,
        user_id TEXT,
        title TEXT NOT NULL,
        original_prompt TEXT NOT NULL,
        destination_id TEXT,
        destination_name TEXT,
        start_date TEXT NOT NULL,
        end_date TEXT NOT NULL,
        created_at TEXT NOT NULL,
        status TEXT NOT NULL,
        estimated_budget REAL,
        cover_image_url TEXT,
        raw_json_response TEXT,
        llm_model TEXT,
        is_live_ai INTEGER NOT NULL DEFAULT 0,
        latency_ms INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // 4. Activities Table
    await db.execute('''
      CREATE TABLE activities (
        id TEXT PRIMARY KEY,
        trip_id TEXT NOT NULL,
        day_number INTEGER NOT NULL,
        activity_type TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        start_time TEXT NOT NULL,
        end_time TEXT NOT NULL,
        cost REAL NOT NULL,
        location TEXT,
        image_url TEXT,
        is_completed INTEGER NOT NULL DEFAULT 0,
        notes TEXT,
        FOREIGN KEY (trip_id) REFERENCES trips (id) ON DELETE CASCADE
      )
    ''');

    // 4. Catalog Transports Table
    await db.execute('''
      CREATE TABLE catalog_transports (
        id TEXT PRIMARY KEY,
        destination TEXT NOT NULL,
        mode TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        cost REAL NOT NULL,
        start_hour INTEGER NOT NULL,
        start_minute INTEGER NOT NULL,
        end_hour INTEGER NOT NULL,
        end_minute INTEGER NOT NULL
      )
    ''');

    // 5. Catalog Hotels Table
    await db.execute('''
      CREATE TABLE catalog_hotels (
        id TEXT PRIMARY KEY,
        destination TEXT NOT NULL,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        cost_per_night REAL NOT NULL,
        check_in_hour INTEGER NOT NULL,
        check_in_minute INTEGER NOT NULL,
        check_out_hour INTEGER NOT NULL,
        check_out_minute INTEGER NOT NULL
      )
    ''');

    // 6. Catalog Spots Table
    await db.execute('''
      CREATE TABLE catalog_spots (
        id TEXT PRIMARY KEY,
        destination TEXT NOT NULL,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        entry_fee REAL NOT NULL,
        duration_minutes INTEGER NOT NULL,
        keywords TEXT NOT NULL
      )
    ''');

    // 7. Catalog Dining Table
    await db.execute('''
      CREATE TABLE catalog_dinings (
        id TEXT PRIMARY KEY,
        destination TEXT NOT NULL,
        meal_type TEXT NOT NULL,
        restaurant_name TEXT NOT NULL,
        description TEXT NOT NULL,
        average_cost REAL NOT NULL
      )
    ''');

    // Seed default demo user: traveler@example.com / password123
    await db.insert('users', {
      'id': 'default-traveler-id',
      'name': 'Alex Morgan',
      'email': 'traveler@example.com',
      'password': 'password123',
      'avatar_url': null,
      'created_at': DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
    });

    // Seed travel catalog into SQLite
    final batch = db.batch();

    for (final t in TravelCatalog.transports) {
      batch.insert('catalog_transports', {
        'id': t.id,
        'destination': t.destination,
        'mode': t.mode,
        'title': t.title,
        'description': t.description,
        'cost': t.cost,
        'start_hour': t.startHour,
        'start_minute': t.startMinute,
        'end_hour': t.endHour,
        'end_minute': t.endMinute,
      });
    }

    for (final h in TravelCatalog.hotels) {
      batch.insert('catalog_hotels', {
        'id': h.id,
        'destination': h.destination,
        'name': h.name,
        'description': h.description,
        'cost_per_night': h.costPerNight,
        'check_in_hour': h.checkInHour,
        'check_in_minute': h.checkInMinute,
        'check_out_hour': h.checkOutHour,
        'check_out_minute': h.checkOutMinute,
      });
    }

    for (final s in TravelCatalog.spots) {
      batch.insert('catalog_spots', {
        'id': s.id,
        'destination': s.destination,
        'name': s.name,
        'description': s.description,
        'entry_fee': s.entryFee,
        'duration_minutes': s.durationMinutes,
        'keywords': jsonEncode(s.keywords),
      });
    }

    for (final d in TravelCatalog.dinings) {
      batch.insert('catalog_dinings', {
        'id': d.id,
        'destination': d.destination,
        'meal_type': d.mealType,
        'restaurant_name': d.restaurantName,
        'description': d.description,
        'average_cost': d.averageCost,
      });
    }

    await batch.commit(noResult: true);
  }

  /// Upgrades SQLite tables and refreshes catalog cache when schema version increments.
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS app_sessions (
          key TEXT PRIMARY KEY,
          value TEXT NOT NULL
        )
      ''');
      try {
        await db.execute('ALTER TABLE trips ADD COLUMN user_id TEXT');
      } catch (_) {}

      // Refresh catalog tables with expanded spots and authentic dinings
      final batch = db.batch();
      batch.delete('catalog_spots');
      batch.delete('catalog_dinings');

      for (final s in TravelCatalog.spots) {
        batch.insert('catalog_spots', {
          'id': s.id,
          'destination': s.destination,
          'name': s.name,
          'description': s.description,
          'entry_fee': s.entryFee,
          'duration_minutes': s.durationMinutes,
          'keywords': jsonEncode(s.keywords),
        });
      }

      for (final d in TravelCatalog.dinings) {
        batch.insert('catalog_dinings', {
          'id': d.id,
          'destination': d.destination,
          'meal_type': d.mealType,
          'restaurant_name': d.restaurantName,
          'description': d.description,
          'average_cost': d.averageCost,
        });
      }

      await batch.commit(noResult: true);
    }
  }

  // --------------------------------------------------------------------------
  // Password Security & Hashing
  // --------------------------------------------------------------------------

  /// Creates a SHA-256 salted hash of passwords for secure SQLite storage.
  String _hashPassword(String password) {
    final bytes = utf8.encode('${password}_trip_salt_2026');
    return sha256.convert(bytes).toString();
  }

  // --------------------------------------------------------------------------
  // User Authentication & Session Management
  // --------------------------------------------------------------------------

  /// Registers a new user account. Hashes password securely. Returns false if email exists.
  Future<bool> registerUser(UserModel user, String password) async {
    final cleanEmail = user.email.trim().toLowerCase();
    final hashedPassword = _hashPassword(password);

    if (kIsWeb) {
      await _ensureWebHydrated();
      if (_webUsers.containsKey(cleanEmail)) return false;
      _webUsers[cleanEmail] = {'user': user, 'password': hashedPassword};
      await _persistWebUsers();
      return true;
    }

    final db = (await database)!;
    final existing = await db.query(
      'users',
      where: 'LOWER(email) = ?',
      whereArgs: [cleanEmail],
    );

    if (existing.isNotEmpty) {
      return false;
    }

    await db.insert('users', {
      'id': user.id,
      'name': user.name,
      'email': cleanEmail,
      'password': hashedPassword,
      'avatar_url': user.avatarUrl,
      'created_at': user.createdAt.toIso8601String(),
    });

    return true;
  }

  /// Verifies credentials against hashed or legacy password. Returns [UserModel] if valid.
  Future<UserModel?> authenticateUser(String email, String password) async {
    final cleanEmail = email.trim().toLowerCase();
    final hashedPassword = _hashPassword(password);

    if (kIsWeb) {
      await _ensureWebHydrated();
      final entry = _webUsers[cleanEmail];
      if (entry != null &&
          (entry['password'] == password || entry['password'] == hashedPassword)) {
        return entry['user'] as UserModel;
      }
      return null;
    }

    final db = (await database)!;
    final results = await db.query(
      'users',
      where: 'LOWER(email) = ? AND (password = ? OR password = ?)',
      whereArgs: [cleanEmail, hashedPassword, password],
    );

    if (results.isNotEmpty) {
      return UserModel.fromMap(results.first);
    }
    return null;
  }

  /// Fetches user by email address.
  Future<UserModel?> getUserByEmail(String email) async {
    final cleanEmail = email.trim().toLowerCase();

    if (kIsWeb) {
      await _ensureWebHydrated();
      final entry = _webUsers[cleanEmail];
      return entry != null ? (entry['user'] as UserModel) : null;
    }

    final db = (await database)!;
    final results = await db.query(
      'users',
      where: 'LOWER(email) = ?',
      whereArgs: [cleanEmail],
    );

    if (results.isNotEmpty) {
      return UserModel.fromMap(results.first);
    }
    return null;
  }

  /// Fetches user by user ID.
  Future<UserModel?> getUserById(String id) async {
    if (kIsWeb) {
      await _ensureWebHydrated();
      for (final entry in _webUsers.values) {
        final user = entry['user'] as UserModel?;
        if (user?.id == id) return user;
      }
      return null;
    }

    final db = (await database)!;
    final results = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return UserModel.fromMap(results.first);
    }
    return null;
  }

  /// Resets a user's password with new hashed credentials.
  Future<bool> resetPassword(String email, String newPassword) async {
    final cleanEmail = email.trim().toLowerCase();
    final hashedPassword = _hashPassword(newPassword);

    if (kIsWeb) {
      await _ensureWebHydrated();
      final entry = _webUsers[cleanEmail];
      if (entry != null) {
        entry['password'] = hashedPassword;
        await _persistWebUsers();
        return true;
      }
      return false;
    }

    final db = (await database)!;
    final rowsAffected = await db.update(
      'users',
      {'password': hashedPassword},
      where: 'LOWER(email) = ?',
      whereArgs: [cleanEmail],
    );

    return rowsAffected > 0;
  }

  /// Persists active user session token in SQLite across app restarts.
  Future<void> saveActiveSession(String userId) async {
    if (kIsWeb) {
      _webActiveUserId = userId;
      await _persistWebSession(userId);
      return;
    }
    final db = (await database)!;
    await db.insert(
      'app_sessions',
      {'key': 'active_user_id', 'value': userId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Retrieves the active user ID session from SQLite.
  Future<String?> getActiveSession() async {
    if (kIsWeb) {
      await _ensureWebHydrated();
      return _webActiveUserId;
    }
    final db = (await database)!;
    final maps = await db.query(
      'app_sessions',
      where: 'key = ?',
      whereArgs: ['active_user_id'],
    );
    if (maps.isNotEmpty) {
      return maps.first['value'] as String?;
    }
    return null;
  }

  /// Clears active user session upon logout.
  Future<void> clearActiveSession() async {
    if (kIsWeb) {
      _webActiveUserId = null;
      await _persistWebSession(null);
      return;
    }
    final db = (await database)!;
    await db.delete(
      'app_sessions',
      where: 'key = ?',
      whereArgs: ['active_user_id'],
    );
  }

  // --------------------------------------------------------------------------
  // Trips (CRUD with User Isolation)
  // --------------------------------------------------------------------------

  /// Inserts a new trip into SQLite.
  Future<void> insertTrip(TripModel trip) async {
    if (kIsWeb) {
      await _ensureWebHydrated();
      _webTrips.removeWhere((t) => t.id == trip.id);
      _webTrips.add(trip);
      await _persistWebTrips();
      return;
    }

    final db = (await database)!;
    await db.insert(
      'trips',
      trip.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Retrieves all trips, optionally filtered by user ID (User Isolation).
  Future<List<TripModel>> getAllTrips({String? userId}) async {
    if (kIsWeb) {
      await _ensureWebHydrated();
      if (userId != null && userId.isNotEmpty) {
        return _webTrips
            .where((t) => t.userId == userId || t.userId == null)
            .toList();
      }
      return List<TripModel>.from(_webTrips);
    }

    final db = (await database)!;
    List<Map<String, dynamic>> maps;
    if (userId != null && userId.isNotEmpty) {
      maps = await db.query(
        'trips',
        where: 'user_id = ? OR user_id IS NULL',
        whereArgs: [userId],
        orderBy: 'created_at ASC',
      );
    } else {
      maps = await db.query('trips', orderBy: 'created_at ASC');
    }
    return maps.map((m) => TripModel.fromMap(m)).toList();
  }

  /// Retrieves a specific trip by its id.
  Future<TripModel?> getTripById(String tripId) async {
    if (kIsWeb) {
      await _ensureWebHydrated();
      final idx = _webTrips.indexWhere((t) => t.id == tripId);
      return idx != -1 ? _webTrips[idx] : null;
    }

    final db = (await database)!;
    final maps = await db.query('trips', where: 'id = ?', whereArgs: [tripId]);
    if (maps.isNotEmpty) {
      return TripModel.fromMap(maps.first);
    }
    return null;
  }

  /// Updates status ('UPCOMING', 'ACTIVE', 'COMPLETED', etc.) of a trip.
  Future<void> updateTripStatus(String tripId, String newStatus) async {
    if (kIsWeb) {
      await _ensureWebHydrated();
      final idx = _webTrips.indexWhere((t) => t.id == tripId);
      if (idx != -1) {
        _webTrips[idx].status = newStatus;
        await _persistWebTrips();
      }
      return;
    }

    final db = (await database)!;
    await db.update(
      'trips',
      {'status': newStatus},
      where: 'id = ?',
      whereArgs: [tripId],
    );
  }

  /// Deletes a trip and its cascaded activities.
  Future<void> deleteTrip(String tripId) async {
    if (kIsWeb) {
      await _ensureWebHydrated();
      _webTrips.removeWhere((t) => t.id == tripId);
      _webActivities.removeWhere((a) => a.tripId == tripId);
      await _persistWebTrips();
      await _persistWebActivities();
      return;
    }

    final db = (await database)!;
    await db.delete('activities', where: 'trip_id = ?', whereArgs: [tripId]);
    await db.delete('trips', where: 'id = ?', whereArgs: [tripId]);
  }

  // --------------------------------------------------------------------------
  // Activities Management
  // --------------------------------------------------------------------------

  /// Inserts a list of activities.
  Future<void> insertActivities(List<ActivityModel> activities) async {
    if (kIsWeb) {
      await _ensureWebHydrated();
      for (final a in activities) {
        _webActivities.removeWhere((x) => x.id == a.id);
        _webActivities.add(a);
      }
      await _persistWebActivities();
      return;
    }

    final db = (await database)!;
    final batch = db.batch();
    for (final a in activities) {
      batch.insert(
        'activities',
        a.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  /// Fetches activities for a trip, ordered by day and start time.
  Future<List<ActivityModel>> getActivitiesForTrip(String tripId) async {
    if (kIsWeb) {
      await _ensureWebHydrated();
      final list = _webActivities.where((a) => a.tripId == tripId).toList();
      list.sort((a, b) {
        if (a.dayNumber != b.dayNumber) return a.dayNumber.compareTo(b.dayNumber);
        return a.startTime.compareTo(b.startTime);
      });
      return list;
    }

    final db = (await database)!;
    final maps = await db.query(
      'activities',
      where: 'trip_id = ?',
      whereArgs: [tripId],
      orderBy: 'day_number ASC, start_time ASC',
    );
    return maps.map((m) => ActivityModel.fromMap(m)).toList();
  }

  /// Toggles the completion status of an activity.
  Future<void> toggleActivityCompletion(String activityId) async {
    if (kIsWeb) {
      await _ensureWebHydrated();
      final index = _webActivities.indexWhere((a) => a.id == activityId);
      if (index != -1) {
        final current = _webActivities[index];
        _webActivities[index] = current.copyWith(isCompleted: !current.isCompleted);
        await _persistWebActivities();
      }
      return;
    }

    final db = (await database)!;
    final maps = await db.query(
      'activities',
      where: 'id = ?',
      whereArgs: [activityId],
    );

    if (maps.isNotEmpty) {
      final current = maps.first['is_completed'] == 1 || maps.first['is_completed'] == true;
      await db.update(
        'activities',
        {'is_completed': current ? 0 : 1},
        where: 'id = ?',
        whereArgs: [activityId],
      );
    }
  }

  // --------------------------------------------------------------------------
  // Step 3: Local Database Travel Catalog Queries (SQLite-powered)
  // --------------------------------------------------------------------------

  /// Checks whether a destination is supported in the local travel catalog.
  bool isDestinationSupported(String destination) {
    return TravelCatalog.isSupported(destination);
  }

  /// Searches matching transport schedules for the destination and mode.
  Future<CatalogTransport> searchTransport({
    required String destination,
    String? mode,
  }) async {
    if (!isDestinationSupported(destination)) {
      throw Exception('Trip not found: destination "$destination" not found in catalog');
    }

    final destLower = destination.trim().toLowerCase();
    final modeLower = mode?.trim().toLowerCase() ?? 'train';

    if (kIsWeb) {
      final matches = TravelCatalog.transports.where((t) {
        final matchesDest = t.destination.toLowerCase().contains(destLower) ||
            destLower.contains(t.destination.toLowerCase());
        final matchesMode = t.mode.toLowerCase().contains(modeLower) ||
            modeLower.contains(t.mode.toLowerCase());
        return matchesDest && matchesMode;
      }).toList();

      if (matches.isNotEmpty) return matches.first;

      final destOnly = TravelCatalog.transports.where((t) {
        return t.destination.toLowerCase().contains(destLower) ||
            destLower.contains(t.destination.toLowerCase());
      }).toList();

      if (destOnly.isNotEmpty) return destOnly.first;

      return TravelCatalog.transports.first;
    }

    final db = (await database)!;
    final maps = await db.query(
      'catalog_transports',
      where: 'LOWER(destination) LIKE ?',
      whereArgs: ['%$destLower%'],
    );

    final transports = maps.map((m) => CatalogTransport(
      id: m['id'] as String,
      destination: m['destination'] as String,
      mode: m['mode'] as String,
      title: m['title'] as String,
      description: m['description'] as String,
      cost: (m['cost'] as num).toDouble(),
      startHour: (m['start_hour'] as num).toInt(),
      startMinute: (m['start_minute'] as num).toInt(),
      endHour: (m['end_hour'] as num).toInt(),
      endMinute: (m['end_minute'] as num).toInt(),
    )).toList();

    // Prefer exact mode match
    final modeMatches = transports.where((t) =>
      t.mode.toLowerCase().contains(modeLower) || modeLower.contains(t.mode.toLowerCase())
    ).toList();

    if (modeMatches.isNotEmpty) return modeMatches.first;
    if (transports.isNotEmpty) return transports.first;

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
    if (!isDestinationSupported(destination)) {
      throw Exception('Trip not found: destination "$destination" not found in catalog');
    }

    final destLower = destination.trim().toLowerCase();

    if (kIsWeb) {
      final matches = TravelCatalog.hotels.where((h) {
        return h.destination.toLowerCase().contains(destLower) ||
            destLower.contains(h.destination.toLowerCase());
      }).toList();

      if (matches.isNotEmpty) return matches.first;
      return TravelCatalog.hotels.first;
    }

    final db = (await database)!;
    final maps = await db.query(
      'catalog_hotels',
      where: 'LOWER(destination) LIKE ?',
      whereArgs: ['%$destLower%'],
    );

    if (maps.isNotEmpty) {
      final m = maps.first;
      return CatalogHotel(
        id: m['id'] as String,
        destination: m['destination'] as String,
        name: m['name'] as String,
        description: m['description'] as String,
        costPerNight: (m['cost_per_night'] as num).toDouble(),
        checkInHour: (m['check_in_hour'] as num).toInt(),
        checkInMinute: (m['check_in_minute'] as num).toInt(),
        checkOutHour: (m['check_out_hour'] as num).toInt(),
        checkOutMinute: (m['check_out_minute'] as num).toInt(),
      );
    }

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
    if (!isDestinationSupported(destination)) {
      throw Exception('Trip not found: destination "$destination" not found in catalog');
    }

    final destLower = destination.trim().toLowerCase();
    final qLower = query?.trim().toLowerCase();

    if (kIsWeb) {
      final destSpots = TravelCatalog.spots.where((s) {
        return s.destination.toLowerCase().contains(destLower) ||
            destLower.contains(s.destination.toLowerCase());
      }).toList();

      if (qLower != null && qLower.isNotEmpty) {
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

      return destSpots.isNotEmpty
          ? destSpots
          : TravelCatalog.spots
              .where((s) => s.destination.toLowerCase().contains(destLower))
              .toList();
    }

    final db = (await database)!;
    final maps = await db.query(
      'catalog_spots',
      where: 'LOWER(destination) LIKE ?',
      whereArgs: ['%$destLower%'],
    );

    var spots = maps.map((m) {
      List<String> keywords = [];
      try {
        final rawKw = m['keywords'];
        if (rawKw is String) {
          keywords = List<String>.from(jsonDecode(rawKw) as List);
        }
      } catch (_) {}
      return CatalogSpot(
        id: m['id'] as String,
        destination: m['destination'] as String,
        name: m['name'] as String,
        description: m['description'] as String,
        entryFee: (m['entry_fee'] as num).toDouble(),
        durationMinutes: (m['duration_minutes'] as num).toInt(),
        keywords: keywords,
      );
    }).toList();

    if (qLower != null && qLower.isNotEmpty) {
      spots.sort((a, b) {
        final aMatch = a.name.toLowerCase().contains(qLower) ||
            a.keywords.any((k) => qLower.contains(k) || k.contains(qLower));
        final bMatch = b.name.toLowerCase().contains(qLower) ||
            b.keywords.any((k) => qLower.contains(k) || k.contains(qLower));
        if (aMatch && !bMatch) return -1;
        if (!aMatch && bMatch) return 1;
        return 0;
      });
    }

    if (spots.isNotEmpty) return spots;

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

  /// Searches dining recommendations (Lunch / Dinner) in destination.
  Future<List<CatalogDining>> searchDining({
    required String destination,
    String? mealType,
  }) async {
    if (!isDestinationSupported(destination)) {
      throw Exception('Trip not found: destination "$destination" not found in catalog');
    }

    final destLower = destination.trim().toLowerCase();
    final mLower = mealType?.trim().toLowerCase();

    if (kIsWeb) {
      final matches = TravelCatalog.dinings.where((d) {
        final matchDest = d.destination.toLowerCase().contains(destLower) ||
            destLower.contains(d.destination.toLowerCase());
        if (mLower != null && mLower.isNotEmpty) {
          return matchDest && d.mealType.toLowerCase() == mLower;
        }
        return matchDest;
      }).toList();

      return matches.isNotEmpty
          ? matches
          : TravelCatalog.dinings
              .where((d) => d.destination.toLowerCase().contains(destLower))
              .toList();
    }

    final db = (await database)!;
    String where = 'LOWER(destination) LIKE ?';
    List<dynamic> whereArgs = ['%$destLower%'];
    if (mLower != null && mLower.isNotEmpty) {
      where += ' AND LOWER(meal_type) = ?';
      whereArgs.add(mLower);
    }

    final maps = await db.query(
      'catalog_dinings',
      where: where,
      whereArgs: whereArgs,
    );

    if (maps.isNotEmpty) {
      return maps.map((m) => CatalogDining(
        id: m['id'] as String,
        destination: m['destination'] as String,
        mealType: m['meal_type'] as String,
        restaurantName: m['restaurant_name'] as String,
        description: m['description'] as String,
        averageCost: (m['average_cost'] as num).toDouble(),
      )).toList();
    }

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

  /// Closes and resets the SQLite database connection (useful for testing and reset).
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
