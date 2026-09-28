import '../core/constants/api_constants.dart';
import '../models/cart.dart';
import 'api_service.dart';

class CartService {
  final ApiService _apiService = ApiService();

  Future<List<Cart>> getCarts() async {
    final response = await _apiService.get(ApiConstants.carts);
    if (response is List) {
      return response.map((item) => Cart.fromJson(item as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<Cart> getCart(int id) async {
    final response = await _apiService.get(ApiConstants.cart(id));
    return Cart.fromJson(response as Map<String, dynamic>);
  }

  Future<List<Cart>> getUserCarts(int userId) async {
    final response = await _apiService.get(ApiConstants.userCarts(userId));
    if (response is List) {
      return response.map((item) => Cart.fromJson(item as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<Cart> addCart({
    required int userId,
    required String date,
    required List<CartItem> products,
  }) async {
    final body = {
      'userId': userId,
      'date': date,
      'products': products.map((e) => {'productId': e.productId, 'quantity': e.quantity}).toList(),
    };
    final response = await _apiService.post(ApiConstants.carts, body);
    return Cart.fromJson(response as Map<String, dynamic>);
  }

  Future<Cart> updateCart({
    required int id,
    required int userId,
    required String date,
    required List<CartItem> products,
  }) async {
    final body = {
      'userId': userId,
      'date': date,
      'products': products.map((e) => {'productId': e.productId, 'quantity': e.quantity}).toList(),
    };
    final response = await _apiService.put(ApiConstants.cart(id), body);
    return Cart.fromJson(response as Map<String, dynamic>);
  }

  Future<bool> deleteCart(int id) async {
    await _apiService.delete(ApiConstants.cart(id));
    return true;
  }
}
