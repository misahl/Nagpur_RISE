class AppConstants {
  static const String appName = 'OrangeAI';
  static const String appTagline = 'AI-Powered Orange Farm Monitoring & Automation';
  static const String defaultFarmName = 'Green Valley Orange Farm';
  static const double defaultLatitude = 21.1458; // Nagpur region citrus belt
  static const double defaultLongitude = 79.0882;

  // Supported languages
  static const List<String> supportedLanguages = [
    'English',
    'Hindi (हिंदी)',
    'Marathi (मराठी)',
    'Kannada (ಕನ್ನಡ)',
    'Malayalam (മലയാളം)',
  ];

  // User Roles
  static const String roleFarmer = 'Farmer';
  static const String roleWorker = 'Farm Worker';
  static const String roleAdmin = 'Admin';

  // Disease Categories
  static const List<String> diseaseClasses = [
    'Healthy',
    'Citrus Canker',
    'Citrus Greening',
    'Pest Damage',
    'Leaf Miner Damage',
    'Nutrient Deficiency',
    'Fungal Infection',
    'Water Stress',
  ];
}
