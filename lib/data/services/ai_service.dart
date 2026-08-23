class AIService {
  /// Simulates parsing a prompt with Gemini to get a structured JSON response.
  Future<Map<String, dynamic>> parsePrompt(String prompt) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    // Mock response
    return {
      'title': 'AI Generated Trip',
      'durationDays': 3,
    };
  }
}
