class ApiConstants {
  // Fake API Base URL
  static const String baseUrl = 'https://fakestoreapi.com';

  // Endpoints
  static const String products = '/products';
  static const String categories = '/products/categories';
  static const String productsByCategory = '/products/category';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
