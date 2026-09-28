import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _productService = ProductService();

  List<Product> _products = [];
  List<String> _categories = [];
  String _selectedCategory = 'all';
  String _searchQuery = '';
  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get products {
    return _products.where((p) {
      final matchesCategory = _selectedCategory == 'all' ||
          p.category.toLowerCase() == _selectedCategory.toLowerCase();
      final matchesSearch = _searchQuery.isEmpty ||
          p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  List<Product> get rawProducts => _products;
  List<String> get categories => ['all', ..._categories];
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final futures = await Future.wait([
        _productService.getProducts(),
        _productService.getCategories(),
      ]);
      _products = futures[0] as List<Product>;
      _categories = futures[1] as List<String>;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Product? findById(int id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<bool> addProduct({
    required String title,
    required double price,
    required String description,
    required String image,
    required String category,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final newProduct = await _productService.addProduct(
        title: title,
        price: price,
        description: description,
        image: image,
        category: category,
      );
      // Ensure unique local ID if API returns dummy id
      final created = Product(
        id: newProduct.id == 0 || _products.any((p) => p.id == newProduct.id)
            ? (_products.isEmpty ? 1 : _products.map((p) => p.id).reduce((a, b) => a > b ? a : b) + 1)
            : newProduct.id,
        title: title,
        price: price,
        description: description,
        image: image.isEmpty
            ? 'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg'
            : image,
        category: category,
        rating: Rating(rate: 5.0, count: 1),
      );
      _products.insert(0, created);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(Product product) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _productService.updateProduct(product);
      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = product;
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProduct(int id) async {
    try {
      await _productService.deleteProduct(id);
      _products.removeWhere((p) => p.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
