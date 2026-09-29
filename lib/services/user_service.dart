import '../core/constants/api_constants.dart';
import '../models/user.dart';
import 'api_service.dart';

class UserService {
  final ApiService _apiService = ApiService();

  Future<List<User>> getUsers() async {
    final response = await _apiService.get(ApiConstants.users);
    if (response is List) {
      return response.map((item) => User.fromJson(item as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<User> getUser(int id) async {
    final response = await _apiService.get(ApiConstants.user(id));
    return User.fromJson(response as Map<String, dynamic>);
  }

  Future<User> addUser(User user) async {
    final response = await _apiService.post(ApiConstants.users, user.toJson());
    if (response is Map<String, dynamic> && response.containsKey('id')) {
      return user.copyWith(id: response['id'] as int);
    }
    return user;
  }

  /// Implements FakeStoreAPI POST /users endpoint
  /// Schema: { "id": 0, "username": string, "email": string, "password": string }
  Future<Map<String, dynamic>> createNewUser({
    required String username,
    required String email,
    required String password,
  }) async {
    final payload = {
      'id': 0,
      'username': username,
      'email': email,
      'password': password,
    };
    final response = await _apiService.post(ApiConstants.users, payload);
    if (response is Map<String, dynamic>) {
      return response;
    }
    return payload;
  }

  Future<User> updateUser(User user) async {
    await _apiService.put(ApiConstants.user(user.id), user.toJson());
    return user;
  }

  Future<bool> deleteUser(int id) async {
    await _apiService.delete(ApiConstants.user(id));
    return true;
  }
}
