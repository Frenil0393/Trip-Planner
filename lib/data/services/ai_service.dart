import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../core/config.dart';

/// Service responsible for communicating with Google Gemini LLM API
/// to convert natural language travel prompts into structured trip itineraries.
class AIService {
  final String apiKey;
  final String modelName;

  AIService({
    String? apiKey,
    String? modelName,
  })  : apiKey = apiKey ?? AppConfig.geminiApiKey,
        modelName = modelName ?? AppConfig.geminiModel;

  /// Parses a natural language prompt using Gemini and returns structured itinerary data.
  ///
  /// Expected return map structure:
  /// {
  ///   'title': String,
  ///   'destination': String,
  ///   'durationDays': int,
  ///   'activities': [
  ///     {
  ///       'dayNumber': int,
  ///       'activityType': String, // 'TRANSPORT', 'HOTEL', 'SIGHTSEEING', 'FOOD'
  ///       'title': String,
  ///       'description': String,
  ///       'startHour': int, // 0-23
  ///       'startMinute': int,
  ///       'endHour': int,
  ///       'endMinute': int,
  ///       'cost': double,
  ///     }
  ///   ]
  /// }
  Future<Map<String, dynamic>> parsePrompt(String prompt) async {
    try {
      final model = GenerativeModel(
        model: modelName,
        apiKey: apiKey,
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
          temperature: 0.4,
        ),
        systemInstruction: Content.system(
          'You are an expert travel planner assistant and AI brain. Given a user travel prompt, '
          'extract key details and generate a comprehensive day-by-day itinerary in strict JSON format. '
          'Extract:\n'
          '- destination (e.g., Paris, Tokyo, Rome, Swiss Alps)\n'
          '- durationDays (e.g., 2, 3, 5)\n'
          '- transportMode (e.g., Train, Flight, Bus)\n'
          '- keySpot (e.g., Eiffel Tower, Colosseum, Shibuya)\n'
          'Your JSON response must match this schema:\n'
          '{\n'
          '  "title": "Short catchy trip title (e.g., Paris Summer Trip)",\n'
          '  "destination": "Paris",\n'
          '  "durationDays": 2,\n'
          '  "transportMode": "Train",\n'
          '  "keySpot": "Eiffel Tower",\n'
          '  "activities": [\n'
          '    {\n'
          '      "dayNumber": 1,\n'
          '      "activityType": "TRANSPORT", // One of: TRANSPORT, HOTEL, SIGHTSEEING, FOOD\n'
          '      "title": "Train departure to Paris",\n'
          '      "description": "Eurostar high-speed rail to Gare du Nord",\n'
          '      "startHour": 9,\n'
          '      "startMinute": 0,\n'
          '      "endHour": 11,\n'
          '      "endMinute": 30,\n'
          '      "cost": 75.0\n'
          '    }\n'
          '  ]\n'
          '}\n'
          'Respond with ONLY valid JSON.',
        ),
      );

      final response = await model.generateContent([Content.text(prompt)]);
      final text = response.text;

      if (text != null && text.isNotEmpty) {
        // Strip markdown code block backticks if present
        String cleanJson = text.trim();
        if (cleanJson.startsWith('```json')) {
          cleanJson = cleanJson.substring(7);
        }
        if (cleanJson.startsWith('```')) {
          cleanJson = cleanJson.substring(3);
        }
        if (cleanJson.endsWith('```')) {
          cleanJson = cleanJson.substring(0, cleanJson.length - 3);
        }

        final decoded = jsonDecode(cleanJson.trim()) as Map<String, dynamic>;
        if (decoded.containsKey('title') && decoded.containsKey('durationDays')) {
          return decoded;
        }
      }
    } catch (e) {
      debugPrint('[AIService] Gemini API error: $e. Falling back to local smart parser.');
    }

    // Fallback: Intelligent local heuristic parser
    return _buildFallbackPlan(prompt);
  }

  /// Generates a realistic mock itinerary based on keywords in the prompt.
  Map<String, dynamic> _buildFallbackPlan(String prompt) {
    final lower = prompt.toLowerCase();

    // 1. Destination Extraction
    String destination = 'Paris';
    if (lower.contains('tokyo') || lower.contains('japan')) {
      destination = 'Tokyo';
    } else if (lower.contains('swiss') || lower.contains('alps') || lower.contains('zermatt')) {
      destination = 'Swiss Alps';
    } else if (lower.contains('rome') || lower.contains('italy')) {
      destination = 'Rome';
    } else if (lower.contains('paris') || lower.contains('france')) {
      destination = 'Paris';
    }

    // 2. Transport Mode Extraction
    String transportMode = 'Train';
    if (lower.contains('flight') || lower.contains('fly') || lower.contains('plane')) {
      transportMode = 'Flight';
    } else if (lower.contains('bus')) {
      transportMode = 'Bus';
    } else {
      transportMode = 'Train';
    }

    // 3. Key Spot Extraction
    String? keySpot;
    if (lower.contains('eiffel')) {
      keySpot = 'Eiffel Tower';
    } else if (lower.contains('louvre')) {
      keySpot = 'Louvre Museum';
    } else if (lower.contains('colosseum')) {
      keySpot = 'Colosseum';
    } else if (lower.contains('vatican')) {
      keySpot = 'Vatican Museums';
    } else if (lower.contains('shibuya')) {
      keySpot = 'Shibuya Crossing';
    } else if (lower.contains('matterhorn')) {
      keySpot = 'Matterhorn';
    }

    // 4. Duration Extraction
    int durationDays = 3;
    final match = RegExp(r'(\d+)\s*(?:day|days)', caseSensitive: false).firstMatch(prompt);
    if (match != null) {
      durationDays = int.tryParse(match.group(1) ?? '3') ?? 3;
      if (durationDays < 1) durationDays = 1;
      if (durationDays > 7) durationDays = 7;
    }

    // Title
    String title = '$destination Summer Trip';
    if (destination == 'Tokyo') {
      title = 'Tokyo Explorer Trip';
    } else if (destination == 'Swiss Alps') {
      title = 'Swiss Alpine Adventure';
    } else if (destination == 'Rome') {
      title = 'Eternal Rome Getaway';
    }

    final activities = <Map<String, dynamic>>[];

    // Day 1: User-specified scheduling pipeline
    // 09:00 AM – 11:30 AM: Train/transport departure
    // 12:00 PM – 01:30 PM: Lunch at local restaurant
    // 02:00 PM – 03:00 PM: Hotel check-in
    // 04:00 PM – 06:00 PM: Sightseeing at Key Spot
    // 07:30 PM – 09:30 PM: Dinner at local restaurant
    activities.addAll([
      {
        'dayNumber': 1,
        'activityType': 'TRANSPORT',
        'title': '$transportMode departure to $destination',
        'description': '$transportMode service direct to $destination central terminal.',
        'startHour': 9,
        'startMinute': 0,
        'endHour': 11,
        'endMinute': 30,
        'cost': transportMode == 'Train' ? 75.0 : 160.0,
      },
      {
        'dayNumber': 1,
        'activityType': 'FOOD',
        'title': 'Lunch at a local restaurant',
        'description': 'Enjoy regional dishes and refreshments after arrival in $destination.',
        'startHour': 12,
        'startMinute': 0,
        'endHour': 13,
        'endMinute': 30,
        'cost': 28.0,
      },
      {
        'dayNumber': 1,
        'activityType': 'HOTEL',
        'title': 'Hotel check-in',
        'description': 'Check in, unpack, and freshen up at your boutique hotel.',
        'startHour': 14,
        'startMinute': 0,
        'endHour': 15,
        'endMinute': 0,
        'cost': 160.0,
      },
      {
        'dayNumber': 1,
        'activityType': 'SIGHTSEEING',
        'title': 'Sightseeing at the ${keySpot ?? '$destination Highlights'}',
        'description': 'Visit the iconic landmark and capture panoramic photos.',
        'startHour': 16,
        'startMinute': 0,
        'endHour': 18,
        'endMinute': 0,
        'cost': 32.0,
      },
      {
        'dayNumber': 1,
        'activityType': 'FOOD',
        'title': 'Dinner at a traditional bistro',
        'description': 'Relax with evening dining and local specialty cuisine.',
        'startHour': 19,
        'startMinute': 30,
        'endHour': 21,
        'endMinute': 30,
        'cost': 45.0,
      },
    ]);

    // Subsequent Days
    for (int day = 2; day <= durationDays; day++) {
      activities.addAll([
        {
          'dayNumber': day,
          'activityType': 'HOTEL',
          'title': 'Breakfast & Morning Prep',
          'description': 'Continental breakfast at hotel and plan of the day.',
          'startHour': 8,
          'startMinute': 30,
          'endHour': 10,
          'endMinute': 0,
          'cost': 20.0,
        },
        {
          'dayNumber': day,
          'activityType': 'SIGHTSEEING',
          'title': '$destination Cultural Highlights (Day $day)',
          'description': 'Guided tour of historical monuments, galleries, and scenic plazas.',
          'startHour': 10,
          'startMinute': 30,
          'endHour': 13,
          'endMinute': 0,
          'cost': 35.0,
        },
        {
          'dayNumber': day,
          'activityType': 'FOOD',
          'title': 'Lunch at City Bistro',
          'description': 'Savor classic regional street food and local lunch specialties.',
          'startHour': 13,
          'startMinute': 0,
          'endHour': 14,
          'endMinute': 30,
          'cost': 26.0,
        },
        {
          'dayNumber': day,
          'activityType': 'SIGHTSEEING',
          'title': 'Afternoon Discovery & Walking Tour',
          'description': 'Stroll through artisan streets, historic bridges, and river views.',
          'startHour': 15,
          'startMinute': 30,
          'endHour': 18,
          'endMinute': 0,
          'cost': 15.0,
        },
        {
          'dayNumber': day,
          'activityType': 'FOOD',
          'title': 'Evening Gourmet Dinner',
          'description': 'Signature dinner experience featuring local wines and chef specials.',
          'startHour': 19,
          'startMinute': 30,
          'endHour': 21,
          'endMinute': 30,
          'cost': 50.0,
        },
      ]);
    }

    final result = <String, dynamic>{
      'title': title,
      'destination': destination,
      'durationDays': durationDays,
      'transportMode': transportMode,
      'activities': activities,
    };
    if (keySpot != null) {
      result['keySpot'] = keySpot;
    }
    return result;
  }
}
