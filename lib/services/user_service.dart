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

  Future<User> updateUser(User user) async {
    await _apiService.put(ApiConstants.user(user.id), user.toJson());
    return user;
  }

  Future<bool> deleteUser(int id) async {
    await _apiService.delete(ApiConstants.user(id));
    return true;
  }
}
