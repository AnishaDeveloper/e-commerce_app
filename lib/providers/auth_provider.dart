import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  String? _token;
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  String? get token => _token;
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _token != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    final userId = prefs.getInt('auth_user_id');
    if (_token != null && userId != null) {
      try {
        _currentUser = await _userService.getUser(userId);
      } catch (_) {
        // Fallback demo profile if offline
        _currentUser = User(
          id: userId,
          email: 'demo@example.com',
          username: prefs.getString('auth_username') ?? 'user',
          password: '',
          name: Name(firstname: 'Demo', lastname: 'User'),
          phone: '1-570-555-0199',
          address: Address(city: 'New York', street: '5th Ave', number: 12, zipcode: '10001'),
        );
      }
      notifyListeners();
    }
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _authService.login(username, password);
      _token = token;

      // Try finding the user details from FakeStoreAPI
      try {
        final users = await _userService.getUsers();
        _currentUser = users.firstWhere(
          (u) => u.username.toLowerCase() == username.toLowerCase(),
          orElse: () => users.first,
        );
      } catch (_) {
        _currentUser = User(
          id: 1,
          email: '$username@fakestore.com',
          username: username,
          password: password,
          name: Name(firstname: username, lastname: ''),
          phone: '123-456-7890',
          address: Address(city: 'Demo City', street: 'Demo Street', number: 1, zipcode: '12345'),
        );
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      await prefs.setString('auth_username', username);
      if (_currentUser != null) {
        await prefs.setInt('auth_user_id', _currentUser!.id);
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      final errStr = e.toString().toLowerCase();
      final isServerUnreachable = errStr.contains('523') ||
          errStr.contains('unreachable') ||
          errStr.contains('500') ||
          errStr.contains('502') ||
          errStr.contains('503') ||
          errStr.contains('network') ||
          errStr.contains('connection');

      // If FakeStoreAPI is down, permit offline demo session for valid inputs so user is not locked out
      if (isServerUnreachable && username.trim().isNotEmpty && password.trim().isNotEmpty) {
        final fallbackToken = 'offline_demo_token_${DateTime.now().millisecondsSinceEpoch}';
        _token = fallbackToken;
        _currentUser = User(
          id: 1,
          email: '$username@fakestore.com',
          username: username,
          password: password,
          name: Name(firstname: username, lastname: 'Demo'),
          phone: '123-456-7890',
          address: Address(city: 'New York', street: '5th Ave', number: 12, zipcode: '10001'),
        );

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', fallbackToken);
        await prefs.setString('auth_username', username);
        await prefs.setInt('auth_user_id', 1);

        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('auth_username');
    await prefs.remove('auth_user_id');
    _token = null;
    _currentUser = null;
    notifyListeners();
  }

  Future<bool> registerUser({
    required String username,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final res = await _userService.createNewUser(
        username: username,
        email: email,
        password: password,
      );

      final newId = (res['id'] as num?)?.toInt() ?? 11;
      _currentUser = User(
        id: newId,
        email: email,
        username: username,
        password: password,
        name: Name(firstname: username, lastname: ''),
        phone: '123-456-7890',
        address: Address(
          city: 'New York',
          street: '5th Ave',
          number: 1,
          zipcode: '10001',
        ),
      );

      final token = 'user_token_${DateTime.now().millisecondsSinceEpoch}';
      _token = token;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      await prefs.setString('auth_username', username);
      await prefs.setInt('auth_user_id', newId);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      final errStr = e.toString().toLowerCase();
      final isServerUnreachable = errStr.contains('523') ||
          errStr.contains('unreachable') ||
          errStr.contains('500') ||
          errStr.contains('502') ||
          errStr.contains('503') ||
          errStr.contains('network') ||
          errStr.contains('connection');

      if (isServerUnreachable) {
        final fallbackToken = 'offline_user_token_${DateTime.now().millisecondsSinceEpoch}';
        _token = fallbackToken;
        _currentUser = User(
          id: 11,
          email: email,
          username: username,
          password: password,
          name: Name(firstname: username, lastname: ''),
          phone: '123-456-7890',
          address: Address(city: 'New York', street: '5th Ave', number: 1, zipcode: '10001'),
        );

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', fallbackToken);
        await prefs.setString('auth_username', username);
        await prefs.setInt('auth_user_id', 11);

        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  void updateCurrentUser(User updatedUser) {
    _currentUser = updatedUser;
    notifyListeners();
  }
}
