import '../core/constants/api_constants.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  Future<String> login(String username, String password) async {
    final response = await _apiService.post(ApiConstants.login, {
      'username': username,
      'password': password,
    });
    if (response is Map<String, dynamic> && response.containsKey('token')) {
      return response['token'] as String;
    }
    throw ApiException('Token not received from auth service');
  }
}
