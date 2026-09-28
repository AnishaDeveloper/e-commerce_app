import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart.dart';
import '../models/product.dart';
import '../services/cart_service.dart';

class CartProvider extends ChangeNotifier {
  final CartService _cartService = CartService();
  final List<CartItem> _items = [];
  bool _isLoading = false;

  List<CartItem> get items => [..._items];
  bool get isLoading => _isLoading;

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount {
    return _items.fold(0.0, (sum, item) {
      final price = item.product?.price ?? 0.0;
      return sum + (price * item.quantity);
    });
  }

  CartProvider() {
    _loadCart();
  }

  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getString('saved_cart_items');
    if (cartData != null) {
      try {
        final List decoded = jsonDecode(cartData);
        _items.clear();
        for (var map in decoded) {
          final item = CartItem.fromJson(map);
          if (map['product'] != null) {
            item.product = Product.fromJson(map['product']);
          }
          _items.add(item);
        }
        notifyListeners();
      } catch (_) {}
    }
  }

  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_items.map((item) {
      final json = item.toJson();
      if (item.product != null) {
        json['product'] = item.product!.toJson();
      }
      return json;
    }).toList());
    await prefs.setString('saved_cart_items', encoded);
  }

  void addToCart(Product product) {
    final index = _items.indexWhere((item) => item.productId == product.id);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(
        quantity: _items[index].quantity + 1,
        product: product,
      );
    } else {
      _items.add(CartItem(
        productId: product.id,
        quantity: 1,
        product: product,
      ));
    }
    _saveCart();
    notifyListeners();

    // Sync with FakeStore API
    _cartService.addCart(
      userId: 1,
      date: DateTime.now().toIso8601String(),
      products: _items,
    ).catchError((_) => Cart(id: 1, userId: 1, date: '', products: []));
  }

  void removeSingleItem(int productId) {
    final index = _items.indexWhere((item) => item.productId == productId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index] = _items[index].copyWith(
          quantity: _items[index].quantity - 1,
        );
      } else {
        _items.removeAt(index);
      }
      _saveCart();
      notifyListeners();
    }
  }

  void removeItem(int productId) {
    _items.removeWhere((item) => item.productId == productId);
    _saveCart();
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _saveCart();
    notifyListeners();
  }

  Future<void> syncWithApiCart(int userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final userCarts = await _cartService.getUserCarts(userId);
      if (userCarts.isNotEmpty) {
        // We have historical carts from API
      }
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
  }
}
