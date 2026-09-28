import '../core/constants/api_constants.dart';
import '../models/product.dart';
import 'api_service.dart';

class ProductService {
  final ApiService _apiService = ApiService();

  Future<List<Product>> getProducts() async {
    final response = await _apiService.get(ApiConstants.products);
    if (response is List) {
      return response.map((item) => Product.fromJson(item as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<List<String>> getCategories() async {
    final response = await _apiService.get(ApiConstants.categories);
    if (response is List) {
      return response.map((item) => item.toString()).toList();
    }
    return [];
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    final response = await _apiService.get(ApiConstants.productsByCategory(category));
    if (response is List) {
      return response.map((item) => Product.fromJson(item as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<Product> getProduct(int id) async {
    final response = await _apiService.get(ApiConstants.product(id));
    return Product.fromJson(response as Map<String, dynamic>);
  }

  Future<Product> addProduct({
    required String title,
    required double price,
    required String description,
    required String image,
    required String category,
  }) async {
    final body = {
      'title': title,
      'price': price,
      'description': description,
      'image': image,
      'category': category,
    };
    final response = await _apiService.post(ApiConstants.products, body);
    return Product.fromJson(response as Map<String, dynamic>);
  }

  Future<Product> updateProduct(Product product) async {
    final body = product.toJson();
    final response = await _apiService.put(ApiConstants.product(product.id), body);
    return Product.fromJson(response as Map<String, dynamic>);
  }

  Future<bool> deleteProduct(int id) async {
    await _apiService.delete(ApiConstants.product(id));
    return true;
  }
}
