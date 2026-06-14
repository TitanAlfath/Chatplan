import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = 'http://localhost:8000';
  static String? _token; // In-memory token storage (sementara)

  static String? get token => _token;

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['access_token'];
        return true;
      }
      return false;
    } catch (e) {
      throw Exception('Gagal menghubungi server: $e');
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['access_token'];
        return true;
      }
      return false;
    } catch (e) {
      throw Exception('Gagal menghubungi server: $e');
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id_token': 'mock-google-token'}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['access_token'];
        return true;
      }
      return false;
    } catch (e) {
      throw Exception('Gagal menghubungi server: $e');
    }
  }
}
