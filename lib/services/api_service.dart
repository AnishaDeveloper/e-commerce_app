import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

class ApiService {
  final http.Client _client = http.Client();

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  Future<dynamic> get(String url) async {
    try {
      final response = await _client.get(Uri.parse(url), headers: _headers);
      return _processResponse(response);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network connection failed: ${e.toString()}');
    }
  }

  Future<dynamic> post(String url, Map<String, dynamic> body) async {
    try {
      final response = await _client.post(
        Uri.parse(url),
        headers: _headers,
        body: jsonEncode(body),
      );
      return _processResponse(response);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network connection failed: ${e.toString()}');
    }
  }

  Future<dynamic> put(String url, Map<String, dynamic> body) async {
    try {
      final response = await _client.put(
        Uri.parse(url),
        headers: _headers,
        body: jsonEncode(body),
      );
      return _processResponse(response);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network connection failed: ${e.toString()}');
    }
  }

  Future<dynamic> delete(String url) async {
    try {
      final response = await _client.delete(Uri.parse(url), headers: _headers);
      return _processResponse(response);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network connection failed: ${e.toString()}');
    }
  }

  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return {};
      try {
        return jsonDecode(response.body);
      } catch (_) {
        return response.body;
      }
    } else if (response.statusCode == 401) {
      throw ApiException('Invalid credentials or unauthorized', 401);
    } else if (response.statusCode == 404) {
      throw ApiException('Resource not found', 404);
    } else if (response.statusCode >= 500) {
      throw ApiException(
        'FakeStoreAPI server is temporarily unreachable (Error ${response.statusCode}). The origin server is offline or experiencing downtime.',
        response.statusCode,
      );
    } else {
      throw ApiException(
        'Server returned error (${response.statusCode})',
        response.statusCode,
      );
    }
  }
}
