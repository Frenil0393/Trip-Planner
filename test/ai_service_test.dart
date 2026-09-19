import 'package:flutter_test/flutter_test.dart';
import 'package:trip_planner/data/services/ai_service.dart';

void main() {
  group('AIService Tests', () {
    test('AIService fallback parser returns structured travel data for Paris', () async {
      // Test fallback parsing with an empty/dummy key to trigger safe fallback
      final aiService = AIService(apiKey: 'dummy_test_key');

      final result = await aiService.parsePrompt('3-day romantic trip to Paris with art and fine dining');

      expect(result.containsKey('title'), true);
      expect(result.containsKey('durationDays'), true);
      expect(result.containsKey('activities'), true);

      expect(result['destination'], 'Paris');
      expect(result['durationDays'], 3);

      final activities = result['activities'] as List;
      expect(activities.isNotEmpty, true);
      expect(activities.length, greaterThanOrEqualTo(3));

      final firstActivity = activities.first as Map<String, dynamic>;
      expect(firstActivity.containsKey('dayNumber'), true);
      expect(firstActivity.containsKey('activityType'), true);
      expect(firstActivity.containsKey('title'), true);
    });

    test('AIService fallback parser detects Tokyo and custom duration', () async {
      final aiService = AIService(apiKey: 'dummy_test_key');

      final result = await aiService.parsePrompt('5 days exploring anime and tech in Tokyo');

      expect(result['destination'], 'Tokyo');
      expect(result['durationDays'], 5);
      final activities = result['activities'] as List;
      expect(activities.any((a) => a['dayNumber'] == 5), true);
    });

    test('AIService fallback parser detects Swiss Alps and Rome', () async {
      final aiService = AIService(apiKey: 'dummy_test_key');

      final alps = await aiService.parsePrompt('4 days hiking in Swiss Alps');
      expect(alps['destination'], 'Swiss Alps');
      expect(alps['durationDays'], 4);

      final rome = await aiService.parsePrompt('2 days historic ruins in Rome');
      expect(rome['destination'], 'Rome');
      expect(rome['durationDays'], 2);
    });
  });
}
