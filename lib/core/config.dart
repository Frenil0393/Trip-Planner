/// Central configuration file for external services and API keys.
///
/// Keeps API credentials and project settings in one place, allowing overrides
/// via `--dart-define=GEMINI_API_KEY=your_key` during compilation.
class AppConfig {
  /// Default Google Gemini API Key provided for the project.
  /// Can be overridden at build time with `--dart-define=GEMINI_API_KEY=...`
  /// or dynamically updated in the Profile screen.
  static const String geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: 'YOUR_GEMINI_API_KEY_HERE',
  );

  /// Google Cloud Project identification.
  static const String projectName = 'projects/668343186409';
  static const String projectNumber = '668343186409';
  static const String projectId = '668343186409';

  /// Friendly name for the credential
  static const String keyName = 'Gemini API Key';

  /// Primary LLM Model name to use for itinerary generation.
  static const String geminiModel = 'gemini-2.5-flash';
}

