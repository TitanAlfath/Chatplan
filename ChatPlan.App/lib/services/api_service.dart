import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static String get baseUrl {
    if (const bool.fromEnvironment('dart.library.html')) {
      return 'http://localhost:8000';
    }
    // Note: To use dart:io Platform, we need to handle web carefully, 
    // but a simpler way is to just use default or provide an abstraction.
    // For simplicity since the user might be testing on Android:
    return 'http://10.0.2.2:8000'; 
  }

  Future<List<dynamic>> getActivities() async {
    final response = await http.get(Uri.parse('$baseUrl/chat/activities'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal memuat aktivitas');
    }
  }

  Future<Map<String, dynamic>> sendChatMessage(String message) async {
    final response = await http.post(
      Uri.parse('$baseUrl/chat/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'message': message}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal mengirim pesan');
    }
  }
}

final apiService = ApiService();
