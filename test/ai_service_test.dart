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

    test('AIService extracts exact 4-day durations across hyphenated, word, and template prompts', () async {
      final aiService = AIService(apiKey: 'dummy_test_key');

      // 1. Hyphenated: "4-day"
      final r1 = await aiService.parsePrompt('4-day trip to Goa');
      expect(r1['destination'], 'Goa');
      expect(r1['durationDays'], 4);
      final act1 = r1['activities'] as List;
      expect(act1.any((a) => a['dayNumber'] == 4), true);

      // 2. Quick idea chip prompt
      final r2 = await aiService.parsePrompt('A 4-day mountain getaway to Manali with Solang Valley, Rohtang Pass, and scenic cafes.');
      expect(r2['destination'], 'Manali');
      expect(r2['durationDays'], 4);
      final act2 = r2['activities'] as List;
      expect(act2.any((a) => a['dayNumber'] == 4), true);

      // 3. Prebaked template prompt
      final r3 = await aiService.parsePrompt('A 4-day hiking adventure in the Swiss Alps with mountain views.');
      expect(r3['destination'], 'Swiss Alps');
      expect(r3['durationDays'], 4);

      // 4. Word number: "four days"
      final r4 = await aiService.parsePrompt('four days in Jaipur exploring palaces');
      expect(r4['destination'], 'Jaipur');
      expect(r4['durationDays'], 4);

      // 5. Shorthand "4d"
      final r5 = await aiService.parsePrompt('Paris 4d holiday');
      expect(r5['destination'], 'Paris');
      expect(r5['durationDays'], 4);

      // 6. Night/day combo
      final r6 = await aiService.parsePrompt('3 nights 4 days in Kerala');
      expect(r6['destination'], 'Kerala');
      expect(r6['durationDays'], 4);
    });

    test('AIService rejects high-level durations like 14 days and returns max duration message', () async {
      final aiService = AIService(apiKey: 'dummy_test_key');

      // 1. 14 days prompt
      final r1 = await aiService.parsePrompt('14 days trip to Goa');
      expect(r1['error'], contains('Trips can only be planned for up to 7 days'));
      expect(r1['destination'], isNull);

      // 2. 10-day prompt
      final r2 = await aiService.parsePrompt('10-day vacation in Paris');
      expect(r2['error'], contains('Trips can only be planned for up to 7 days'));

      // 3. 2 weeks prompt
      final r3 = await aiService.parsePrompt('2 weeks in Manali exploring mountains');
      expect(r3['error'], contains('Trips can only be planned for up to 7 days'));

      // 4. Details execution result
      final details = await aiService.parsePromptWithDetails('I want to go to Goa for 14 days');
      expect(details.errorMessage, contains('Trips can only be planned for up to 7 days'));
      expect(details.parsedData['destination'], isNull);
    });

    test('AIService returns Trip not found and no dummy data for unsupported destination (e.g. Junagadh)', () async {
      final aiService = AIService(apiKey: 'dummy_test_key');

      final result = await aiService.parsePrompt('I go to junagadh ');
      expect(result['error'], 'Trip not found');
      expect(result['destination'], isNull);
      expect(result.containsKey('activities'), false);

      final details = await aiService.parsePromptWithDetails('I go to junagadh ');
      expect(details.errorMessage, 'Trip not found');
      expect(details.parsedData['error'], 'Trip not found');
      expect(details.parsedData.containsKey('activities'), false);
    });
  });
}

