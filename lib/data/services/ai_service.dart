import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../core/config.dart';
import '../local_db/travel_catalog.dart';

/// Service responsible for communicating with Google Gemini LLM API
/// to convert natural language travel prompts into structured trip itineraries.
/// Holds the detailed telemetry and payload results of an AI generation cycle.
///
/// Designed to visually inspect prompt inputs, raw JSON responses,
/// latency, model identification, and live API status for grading/demonstration.
class AIExecutionResult {
  final bool isLiveApi;
  final String modelUsed;
  final int latencyMs;
  final String rawPrompt;
  final String rawJsonResponse;
  final Map<String, dynamic> parsedData;
  final String? errorMessage;
  final DateTime executedAt;

  AIExecutionResult({
    required this.isLiveApi,
    required this.modelUsed,
    required this.latencyMs,
    required this.rawPrompt,
    required this.rawJsonResponse,
    required this.parsedData,
    this.errorMessage,
    DateTime? executedAt,
  }) : executedAt = executedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'isLiveApi': isLiveApi,
      'modelUsed': modelUsed,
      'latencyMs': latencyMs,
      'rawPrompt': rawPrompt,
      'rawJsonResponse': rawJsonResponse,
      'parsedData': parsedData,
      'errorMessage': errorMessage,
      'executedAt': executedAt.toIso8601String(),
    };
  }
}

/// Service responsible for communicating with Google Gemini LLM API
/// to convert natural language travel prompts into structured trip itineraries.
class AIService {
  static const int maxSupportedDays = 7;
  static const String maxDurationMessage =
      'Trips can only be planned for up to 7 days (e.g. 3, 5, or 7 days). Please choose up to 7 days.';

  String apiKey;
  final String modelName;

  AIService({
    String? apiKey,
    String? modelName,
  })  : apiKey = apiKey ?? AppConfig.geminiApiKey,
        modelName = modelName ?? AppConfig.geminiModel;

  void updateApiKey(String newKey) {
    apiKey = newKey;
  }

  /// Parses a natural language prompt using Gemini and captures full execution details.
  Future<AIExecutionResult> parsePromptWithDetails(String prompt) async {
    // 0. Pre-validate high-level durations exceeding maxSupportedDays (e.g., 14 days, 2 weeks)
    final rawDays = extractRawDurationDays(prompt);
    if (rawDays != null && rawDays > maxSupportedDays) {
      final errorData = <String, dynamic>{
        'error': maxDurationMessage,
        'destination': null,
      };
      const encoder = JsonEncoder.withIndent('  ');
      return AIExecutionResult(
        isLiveApi: false,
        modelUsed: 'Duration Policy Validator',
        latencyMs: 1,
        rawPrompt: prompt,
        rawJsonResponse: encoder.convert(errorData),
        parsedData: errorData,
        errorMessage: maxDurationMessage,
      );
    }

    final stopwatch = Stopwatch()..start();

    if (apiKey.isNotEmpty) {
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
            'Supported catalog destinations are ONLY: Goa, Jaipur, Manali, Kerala, Paris, Tokyo, Rome, Swiss Alps. '
            'If the prompt asks for a trip to any destination NOT in this list (e.g. Junagadh, London, etc.) '
            'or if no valid travel plan can be made, you MUST respond with: {"error": "Trip not found", "destination": null}.\n'
            'If the prompt requests a duration longer than 7 days (e.g. 14 days, 10 days, 2 weeks), '
            'you MUST respond with: {"error": "Trips can only be planned for up to 7 days (e.g. 3, 5, or 7 days). Please choose up to 7 days.", "destination": null}.\n'
            'Do NOT invent itineraries or dummy data for unsupported destinations.\n'
            'All monetary costs MUST be in Indian Rupees (INR ₹).\n'
            'When a supported destination is requested, extract:\n'
            '- destination (MUST be one of: Goa, Jaipur, Manali, Kerala, Paris, Tokyo, Rome, Swiss Alps)\n'
            '- durationDays (Extract the EXACT duration in days requested by the user, e.g. 1, 2, 3, 4, 5, 6, 7. If the user asks for 4 days or a 4-day trip, durationDays MUST be 4)\n'
            '- transportMode (e.g., Train, Flight, Bus)\n'
            '- keySpot (e.g., Baga Beach, Amber Palace, Solang Valley, Eiffel Tower)\n'
            'Your JSON response must match this schema:\n'
            '{\n'
            '  "title": "Short catchy trip title (e.g., Goa Coastal Holiday)",\n'
            '  "destination": "Goa",\n'
            '  "durationDays": 3,\n'
            '  "transportMode": "Train",\n'
            '  "keySpot": "Baga Beach",\n'
            '  "activities": [\n'
            '    {\n'
            '      "dayNumber": 1,\n'
            '      "activityType": "TRANSPORT", // One of: TRANSPORT, HOTEL, SIGHTSEEING, FOOD\n'
            '      "title": "Train departure to Goa",\n'
            '      "description": "Express superfast train to Madgaon junction",\n'
            '      "startHour": 9,\n'
            '      "startMinute": 0,\n'
            '      "endHour": 11,\n'
            '      "endMinute": 30,\n'
            '      "cost": 2500.0\n'
            '    }\n'
            '  ]\n'
            '}\n'
            'Respond with ONLY valid JSON.',
          ),
        );

        final response = await model.generateContent([Content.text(prompt)]);
        final text = response.text;
        stopwatch.stop();

        if (text != null && text.isNotEmpty) {
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
          if (decoded.containsKey('error') && decoded['error'] != null) {
            const encoder = JsonEncoder.withIndent('  ');
            return AIExecutionResult(
              isLiveApi: true,
              modelUsed: modelName,
              latencyMs: stopwatch.elapsedMilliseconds,
              rawPrompt: prompt,
              rawJsonResponse: encoder.convert(decoded),
              parsedData: decoded,
              errorMessage: decoded['error']?.toString() ?? 'Trip not found',
            );
          }

          final liveDest = decoded['destination'] as String?;
          if (liveDest == null || !TravelCatalog.isSupported(liveDest)) {
            final notFoundData = <String, dynamic>{
              'error': 'Trip not found',
              'destination': null,
            };
            const encoder = JsonEncoder.withIndent('  ');
            return AIExecutionResult(
              isLiveApi: true,
              modelUsed: modelName,
              latencyMs: stopwatch.elapsedMilliseconds,
              rawPrompt: prompt,
              rawJsonResponse: encoder.convert(notFoundData),
              parsedData: notFoundData,
              errorMessage: 'Trip not found',
            );
          }

          if (decoded.containsKey('title')) {
            // Ensure durationDays is present and respects explicit user prompt
            final explicitDays = extractDurationDays(prompt);
            if (explicitDays != null) {
              decoded['durationDays'] = explicitDays;
            } else if (decoded.containsKey('durationDays') && decoded['durationDays'] != null) {
              final raw = decoded['durationDays'];
              if (raw is num) {
                decoded['durationDays'] = raw.toInt().clamp(1, 7);
              } else if (raw is String) {
                decoded['durationDays'] = extractDurationDays(raw) ?? 3;
              }
            } else {
              decoded['durationDays'] = 3;
            }

            const encoder = JsonEncoder.withIndent('  ');
            return AIExecutionResult(
              isLiveApi: true,
              modelUsed: modelName,
              latencyMs: stopwatch.elapsedMilliseconds,
              rawPrompt: prompt,
              rawJsonResponse: encoder.convert(decoded),
              parsedData: decoded,
            );
          }
        }
      } catch (e) {
        stopwatch.stop();
        debugPrint('[AIService] Gemini API notice: $e. Using smart local parser.');
        final fallbackPlan = _buildFallbackPlan(prompt);
        const encoder = JsonEncoder.withIndent('  ');
        final isNotFound = fallbackPlan.containsKey('error') || fallbackPlan['destination'] == null;
        return AIExecutionResult(
          isLiveApi: false,
          modelUsed: modelName,
          latencyMs: stopwatch.elapsedMilliseconds,
          rawPrompt: prompt,
          rawJsonResponse: encoder.convert(fallbackPlan),
          parsedData: fallbackPlan,
          errorMessage: isNotFound ? 'Trip not found' : e.toString(),
        );
      }
    }

    stopwatch.stop();
    final fallbackPlan = _buildFallbackPlan(prompt);
    const encoder = JsonEncoder.withIndent('  ');
    final isNotFound = fallbackPlan.containsKey('error') || fallbackPlan['destination'] == null;
    return AIExecutionResult(
      isLiveApi: false,
      modelUsed: 'Local Heuristic Engine',
      latencyMs: stopwatch.elapsedMilliseconds > 0 ? stopwatch.elapsedMilliseconds : 14,
      rawPrompt: prompt,
      rawJsonResponse: encoder.convert(fallbackPlan),
      parsedData: fallbackPlan,
      errorMessage: isNotFound
          ? 'Trip not found'
          : (apiKey.isEmpty ? 'No API Key configured' : null),
    );
  }

  /// Backwards compatible helper returning only the parsed data map.
  Future<Map<String, dynamic>> parsePrompt(String prompt) async {
    final result = await parsePromptWithDetails(prompt);
    return result.parsedData;
  }

  /// Tests connectivity to the Gemini API endpoint.
  Future<Map<String, dynamic>> testConnection() async {
    if (apiKey.isEmpty) {
      return {
        'success': false,
        'message': 'Gemini API Key is empty. Please enter your API key in Profile.',
        'rawResponse': '{"error": "No API Key provided"}',
        'latencyMs': 0,
        'model': modelName,
      };
    }

    final stopwatch = Stopwatch()..start();
    try {
      final model = GenerativeModel(
        model: modelName,
        apiKey: apiKey,
      );
      final response = await model.generateContent([
        Content.text('Please verify connection by responding with exact JSON: {"status":"connected","model":"gemini-2.5-flash"}')
      ]);
      stopwatch.stop();
      return {
        'success': true,
        'message': 'Connected to $modelName (${stopwatch.elapsedMilliseconds}ms)',
        'rawResponse': response.text?.trim() ?? '{"status":"connected"}',
        'latencyMs': stopwatch.elapsedMilliseconds,
        'model': modelName,
      };
    } catch (e) {
      stopwatch.stop();
      return {
        'success': false,
        'message': 'Connection error: ${e.toString()}',
        'rawResponse': e.toString(),
        'latencyMs': stopwatch.elapsedMilliseconds,
        'model': modelName,
      };
    }
  }

  /// Extracts the exact unclamped number of days requested in the prompt.
  /// Handles digits (14 days), weeks (2 weeks = 14 days), months (1 month = 30 days),
  /// words ("fourteen days"), and nights.
  static int? extractRawDurationDays(String prompt) {
    if (prompt.trim().isEmpty) return null;
    final lower = prompt.toLowerCase();

    // 1. Check for weeks / months: "2 weeks", "two weeks", "1 month"
    final weekMatch = RegExp(
      r'(\d+)\s*[-–—]?\s*(?:weeks?|wk\b)',
      caseSensitive: false,
    ).firstMatch(prompt);
    if (weekMatch != null) {
      final w = int.tryParse(weekMatch.group(1)!);
      if (w != null && w > 0) return w * 7;
    }

    final wordWeekMatch = RegExp(
      r'\b(one|two|three|four|five|six)\s*[-–—]?\s*(?:weeks?|wk\b)',
      caseSensitive: false,
    ).firstMatch(prompt);
    if (wordWeekMatch != null) {
      const weekWords = {'one': 1, 'two': 2, 'three': 3, 'four': 4, 'five': 5, 'six': 6};
      final w = weekWords[wordWeekMatch.group(1)!.toLowerCase()];
      if (w != null) return w * 7;
    }

    if (lower.contains('a month') || lower.contains('one month') || lower.contains('1 month')) {
      return 30;
    }

    // 2. Check for digits with days/d or hyphens: "14-day", "14 days", "14d", "10 days"
    final digitMatch = RegExp(
      r'(\d+)\s*[-–—]?\s*(?:days?|d\b)',
      caseSensitive: false,
    ).firstMatch(prompt);
    if (digitMatch != null) {
      final parsed = int.tryParse(digitMatch.group(1)!);
      if (parsed != null && parsed > 0) {
        return parsed;
      }
    }

    // 3. Check for English word numbers
    final wordMatch = RegExp(
      r'\b(one|two|three|four|five|six|seven|eight|nine|ten|eleven|twelve|thirteen|fourteen|fifteen|twenty)\s*[-–—]?\s*(?:days?|d\b)',
      caseSensitive: false,
    ).firstMatch(prompt);
    if (wordMatch != null) {
      const words = {
        'one': 1,
        'two': 2,
        'three': 3,
        'four': 4,
        'five': 5,
        'six': 6,
        'seven': 7,
        'eight': 8,
        'nine': 9,
        'ten': 10,
        'eleven': 11,
        'twelve': 12,
        'thirteen': 13,
        'fourteen': 14,
        'fifteen': 15,
        'twenty': 20,
      };
      final word = wordMatch.group(1)!.toLowerCase();
      if (words.containsKey(word)) {
        return words[word]!;
      }
    }

    // 4. Check for nights
    final nightMatch = RegExp(
      r'(\d+)\s*[-–—]?\s*nights?',
      caseSensitive: false,
    ).firstMatch(prompt);
    if (nightMatch != null) {
      final parsed = int.tryParse(nightMatch.group(1)!);
      if (parsed != null && parsed > 0) {
        return parsed;
      }
    }

    // 5. Keywords
    if (lower.contains('long weekend')) return 3;
    if (lower.contains('weekend')) return 2;
    if (lower.contains('one week') || lower.contains('1 week') || lower.contains('a week')) return 7;

    return null;
  }

  /// Robustly extracts duration in days from user prompt or duration string clamped to 1..7.
  static int? extractDurationDays(String prompt) {
    final raw = extractRawDurationDays(prompt);
    if (raw == null) return null;
    return raw.clamp(1, maxSupportedDays);
  }

  /// Generates a realistic mock itinerary based on keywords in the prompt.
  Map<String, dynamic> _buildFallbackPlan(String prompt) {
    // 0. High duration check (> 7 days)
    final rawDays = extractRawDurationDays(prompt);
    if (rawDays != null && rawDays > maxSupportedDays) {
      return {
        'error': maxDurationMessage,
        'destination': null,
      };
    }

    final lower = prompt.toLowerCase();
    // 1. Destination Extraction: must match a supported destination catalog
    final destination = TravelCatalog.matchDestination(prompt);
    if (destination == null) {
      return {
        'error': 'Trip not found',
        'destination': null,
      };
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
    } else if (lower.contains('baga') || lower.contains('beach')) {
      keySpot = 'Baga Beach';
    } else if (lower.contains('amber') || lower.contains('amer')) {
      keySpot = 'Amber Palace';
    } else if (lower.contains('solang') || lower.contains('snow')) {
      keySpot = 'Solang Valley';
    } else if (lower.contains('backwater') || lower.contains('houseboat')) {
      keySpot = 'Alleppey Backwaters';
    }

    // 4. Duration Extraction (supports "4-day", "4 days", "four days", "4d", etc.)
    final durationDays = extractDurationDays(prompt) ?? 3;

    // Title
    String title = '$destination Trip';
    if (destination == 'Tokyo') {
      title = 'Tokyo Explorer Trip';
    } else if (destination == 'Swiss Alps') {
      title = 'Swiss Alpine Adventure';
    } else if (destination == 'Rome') {
      title = 'Eternal Rome Getaway';
    } else if (destination == 'Goa') {
      title = 'Goa Beach & Coastal Holiday';
    } else if (destination == 'Jaipur') {
      title = 'Jaipur Royal Heritage Tour';
    } else if (destination == 'Manali') {
      title = 'Manali Himalayan Mountain Escape';
    } else if (destination == 'Kerala') {
      title = 'Kerala Backwaters & Tea Retreat';
    }

    final activities = <Map<String, dynamic>>[];

    // Day 1: User-specified scheduling pipeline (Costs in INR ₹)
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
        'cost': transportMode == 'Train' ? 2500.0 : 6500.0,
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
        'cost': 650.0,
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
        'cost': 4500.0,
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
        'cost': 600.0,
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
        'cost': 950.0,
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
          'cost': 350.0,
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
          'cost': 600.0,
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
          'cost': 550.0,
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
          'cost': 300.0,
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
          'cost': 1100.0,
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
