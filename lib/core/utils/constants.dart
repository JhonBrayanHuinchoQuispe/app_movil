class AppConstants {
  // URLs de API
  static const String baseUrl = 'https://api.boticasanantonio.com';
  static const String loginEndpoint = '/auth/login';
  static const String productsEndpoint = '/products';
  
  // Claves de SharedPreferences
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String rememberMeKey = 'remember_me';
  
  // Configuraciones
  static const int timeoutDuration = 30; // segundos
}