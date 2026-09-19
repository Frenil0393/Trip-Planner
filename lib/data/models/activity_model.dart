import 'dart:convert';
import 'package:flutter/material.dart';

/// Enum classifying the standard travel event / activity types.
enum ActivityType {
  transport,
  hotel,
  sightseeing,
  food,
  entertainment,
  other;

  /// Parses a string into an [ActivityType] safely, defaulting to [other].
  static ActivityType fromString(String? value) {
    if (value == null) return ActivityType.other;
    final clean = value.trim().toUpperCase();
    switch (clean) {
      case 'TRANSPORT':
      case 'FLIGHT':
      case 'TRAIN':
      case 'BUS':
        return ActivityType.transport;
      case 'HOTEL':
      case 'ACCOMMODATION':
      case 'STAY':
        return ActivityType.hotel;
      case 'SIGHTSEEING':
      case 'ATTRACTION':
      case 'TOUR':
        return ActivityType.sightseeing;
      case 'FOOD':
      case 'RESTAURANT':
      case 'MEAL':
      case 'DINING':
        return ActivityType.food;
      case 'ENTERTAINMENT':
      case 'NIGHTLIFE':
        return ActivityType.entertainment;
      default:
        return ActivityType.other;
    }
  }

  /// Converts the enum to standard database/API code.
  String toCode() {
    switch (this) {
      case ActivityType.transport:
        return 'TRANSPORT';
      case ActivityType.hotel:
        return 'HOTEL';
      case ActivityType.sightseeing:
        return 'SIGHTSEEING';
      case ActivityType.food:
        return 'FOOD';
      case ActivityType.entertainment:
        return 'ENTERTAINMENT';
      case ActivityType.other:
        return 'OTHER';
    }
  }

  /// Human-readable display label (e.g. for chips and UI filters).
  String get displayName {
    switch (this) {
      case ActivityType.transport:
        return 'Transport';
      case ActivityType.hotel:
        return 'Stay';
      case ActivityType.sightseeing:
        return 'Sightseeing';
      case ActivityType.food:
        return 'Dining';
      case ActivityType.entertainment:
        return 'Entertainment';
      case ActivityType.other:
        return 'Activity';
    }
  }

  /// Default Material icon for this activity category.
  IconData get icon {
    switch (this) {
      case ActivityType.transport:
        return Icons.flight_takeoff;
      case ActivityType.hotel:
        return Icons.hotel;
      case ActivityType.sightseeing:
        return Icons.camera_alt;
      case ActivityType.food:
        return Icons.restaurant;
      case ActivityType.entertainment:
        return Icons.theater_comedy;
      case ActivityType.other:
        return Icons.place;
    }
  }
}

/// Represents a single scheduled activity or event within a trip itinerary.
///
/// Each activity belongs to a parent trip (`tripId`) and is assigned to a
/// specific day (`dayNumber`). It includes time boundaries, cost, classification,
/// and optional metadata (like photo URLs, locations, and completion status).
class ActivityModel {
  /// Unique identifier (UUID) for this activity.
  final String id;

  /// Foreign key linking this activity to a parent [TripModel].
  final String tripId;

  /// 1-based day index within the itinerary (e.g., 1 for Day 1, 2 for Day 2).
  final int dayNumber;

  /// String code for the type ('TRANSPORT', 'HOTEL', 'SIGHTSEEING', 'FOOD', etc.).
  /// Preserved as [String] for full backward compatibility with existing services.
  final String activityType;

  /// Concise title of the event (e.g. "Flight to Paris", "Eiffel Tower Visit").
  final String title;

  /// Detailed description, booking info, or instructions.
  final String description;

  /// Scheduled start time for this activity.
  final DateTime startTime;

  /// Scheduled end time for this activity.
  final DateTime endTime;

  /// Estimated or confirmed cost for this activity in local currency.
  final double cost;

  /// Optional location name, address, or coordinates.
  final String? location;

  /// Optional image URL to display in cards or detail sheets.
  final String? imageUrl;

  /// Flag indicating if the user has checked off / completed this activity.
  final bool isCompleted;

  /// Optional personal notes or booking reference numbers.
  final String? notes;

  ActivityModel({
    required this.id,
    required this.tripId,
    required this.dayNumber,
    required this.activityType,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.cost,
    this.location,
    this.imageUrl,
    this.isCompleted = false,
    this.notes,
  });

  // --------------------------------------------------------------------------
  // Computed Getters & Helpers
  // --------------------------------------------------------------------------

  /// Strongly-typed enum representation of [activityType].
  ActivityType get typeEnum => ActivityType.fromString(activityType);

  /// Duration of this activity in whole minutes.
  int get durationInMinutes => endTime.difference(startTime).inMinutes;

  /// Formatted human-readable duration (e.g. "2h 30m" or "45m").
  String get formattedDuration {
    final minutes = durationInMinutes;
    if (minutes <= 0) return '0m';
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    if (hours == 0) return '${remainingMinutes}m';
    if (remainingMinutes == 0) return '${hours}h';
    return '${hours}h ${remainingMinutes}m';
  }

  /// Whether this activity is free of charge.
  bool get isFree => cost <= 0.0;

  // --------------------------------------------------------------------------
  // Immutability: copyWith
  // --------------------------------------------------------------------------

  /// Creates a copy of this [ActivityModel] with updated fields.
  ActivityModel copyWith({
    String? id,
    String? tripId,
    int? dayNumber,
    String? activityType,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    double? cost,
    String? location,
    String? imageUrl,
    bool? isCompleted,
    String? notes,
  }) {
    return ActivityModel(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      dayNumber: dayNumber ?? this.dayNumber,
      activityType: activityType ?? this.activityType,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      cost: cost ?? this.cost,
      location: location ?? this.location,
      imageUrl: imageUrl ?? this.imageUrl,
      isCompleted: isCompleted ?? this.isCompleted,
      notes: notes ?? this.notes,
    );
  }

  // --------------------------------------------------------------------------
  // Serialization (SQLite & REST / LLM JSON)
  // --------------------------------------------------------------------------

  /// Converts this [ActivityModel] to a [Map] for SQLite storage or JSON payload.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'trip_id': tripId,
      'day_number': dayNumber,
      'activity_type': activityType,
      'title': title,
      'description': description,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'cost': cost,
      'location': location,
      'image_url': imageUrl,
      'is_completed': isCompleted ? 1 : 0, // SQLite boolean as integer
      'notes': notes,
    };
  }

  /// Creates an [ActivityModel] from a [Map] (SQLite row or JSON object).
  factory ActivityModel.fromMap(Map<String, dynamic> map) {
    return ActivityModel(
      id: (map['id'] ?? '') as String,
      tripId: (map['trip_id'] ?? map['tripId'] ?? '') as String,
      dayNumber: ((map['day_number'] ?? map['dayNumber'] ?? 1) as num).toInt(),
      activityType: (map['activity_type'] ?? map['activityType'] ?? 'OTHER') as String,
      title: (map['title'] ?? '') as String,
      description: (map['description'] ?? '') as String,
      startTime: map['start_time'] != null
          ? DateTime.parse(map['start_time'] as String)
          : (map['startTime'] is DateTime
              ? map['startTime'] as DateTime
              : DateTime.now()),
      endTime: map['end_time'] != null
          ? DateTime.parse(map['end_time'] as String)
          : (map['endTime'] is DateTime
              ? map['endTime'] as DateTime
              : DateTime.now().add(const Duration(hours: 1))),
      cost: ((map['cost'] ?? 0.0) as num).toDouble(),
      location: map['location'] as String?,
      imageUrl: (map['image_url'] ?? map['imageUrl']) as String?,
      isCompleted: map['is_completed'] == 1 ||
          map['is_completed'] == true ||
          map['isCompleted'] == true,
      notes: map['notes'] as String?,
    );
  }

  /// Serializes directly to a JSON string.
  String toJson() => jsonEncode(toMap());

  /// Deserializes directly from a JSON string.
  factory ActivityModel.fromJson(String source) =>
      ActivityModel.fromMap(jsonDecode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ActivityModel(id: $id, day: $dayNumber, type: $activityType, title: $title, cost: \$$cost)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ActivityModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
