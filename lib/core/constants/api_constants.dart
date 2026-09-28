class ApiConstants {
  static const String baseUrl = 'https://fakestoreapi.com';

  // Auth
  static const String login = '$baseUrl/auth/login';

  // Products
  static const String products = '$baseUrl/products';
  static const String categories = '$baseUrl/products/categories';
  static String productsByCategory(String category) => '$baseUrl/products/category/$category';
  static String product(int id) => '$baseUrl/products/$id';

  // Carts
  static const String carts = '$baseUrl/carts';
  static String cart(int id) => '$baseUrl/carts/$id';
  static String userCarts(int userId) => '$baseUrl/carts/user/$userId';

  // Users
  static const String users = '$baseUrl/users';
  static String user(int id) => '$baseUrl/users/$id';
}
