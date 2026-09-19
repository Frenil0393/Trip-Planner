/// Central configuration file for external services and API keys.
///
/// Keeps API credentials and project settings in one place, allowing overrides
/// via `--dart-define=GEMINI_API_KEY=your_key` during compilation.
class AppConfig {
  /// Default Google Gemini API Key provided for the project.
  /// Can be overridden at build time with `--dart-define=GEMINI_API_KEY=...`.
  static const String geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );

  /// Google Cloud Project identification.
  static const String projectName = 'projects/623777684005';
  static const String projectNumber = '623777684005';
  static const String projectId = 'gen-lang-client-0521898417';

  /// Primary LLM Model name to use for itinerary generation.
  static const String geminiModel = 'gemini-1.5-flash';
}
