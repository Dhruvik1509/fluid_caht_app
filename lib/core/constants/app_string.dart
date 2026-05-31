// lib/utils/app_constants.dart
class AppConstants {
  // App Information
  static const String appName = 'Connect';
  static const String version = '1.0.0';

  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  static const String userEmailKey = 'user_email';
  static const String userNameKey = 'user_name';
  static const String userAvatarKey = 'user_avatar';
  static const String isLoggedInKey = 'is_logged_in';
  static const String themeModeKey = 'theme_mode';

  // API Endpoints (Replace with actual URLs)
  static const String baseUrl = 'https://api.connect.app';
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String profileEndpoint = '/user/profile';
  static const String contactsEndpoint = '/contacts';
  static const String messagesEndpoint = '/messages';
  static const String callsEndpoint = '/calls';
  static const String statusEndpoint = '/status';

  // Pagination
  static const int pageSize = 20;
  static const int initialPage = 1;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultMargin = 20.0;
  static const double defaultRadius = 12.0;
  static const double defaultIconSize = 24.0;
  static const double avatarSizeSmall = 32.0;
  static const double avatarSizeMedium = 48.0;
  static const double avatarSizeLarge = 56.0;
  static const double avatarSizeExtraLarge = 96.0;

  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // Time Formats
  static const String timeFormat12h = 'h:mm a';
  static const String timeFormat24h = 'HH:mm';
  static const String dateFormat = 'MMM dd, yyyy';
  static const String dateTimeFormat = 'MMM dd, yyyy h:mm a';

  // Message Status
  static const String messageStatusSending = 'sending';
  static const String messageStatusSent = 'sent';
  static const String messageStatusDelivered = 'delivered';
  static const String messageStatusRead = 'read';
  static const String messageStatusFailed = 'failed';

  // Call Types
  static const String callTypeAudio = 'audio';
  static const String callTypeVideo = 'video';

  // Call Status
  static const String callStatusIncoming = 'incoming';
  static const String callStatusOutgoing = 'outgoing';
  static const String callStatusMissed = 'missed';
  static const String callStatusAnswered = 'answered';
  static const String callStatusDeclined = 'declined';

  // Status Duration
  static const Duration statusDuration = Duration(hours: 24);
}