class EnvConfig {
  /// Gemini API Key
  static const String geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: 'AIzaSyAL9xxNzydBmzQkHXv8Qt2mQ00LqD2PKzU',
  );

  /// Cloudinary API Key
  static const String cloudinaryApiKey = String.fromEnvironment(
    'CLOUDINARY_API_KEY',
    defaultValue: '786232266633578',
  );

  /// Cloudinary API Secret
  static const String cloudinaryApiSecret = String.fromEnvironment(
    'CLOUDINARY_API_SECRET',
    defaultValue: 'zcTdd4tyRX_ks2_Ze19LI5wZ0us',
  );

  /// Cloudinary Cloud Name
  static const String cloudinaryCloudName = String.fromEnvironment(
    'CLOUDINARY_CLOUD_NAME',
    defaultValue: 'dplpu9uc5',
  );
}
