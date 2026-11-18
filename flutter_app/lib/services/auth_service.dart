import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'api_client.dart';

class AuthService extends ChangeNotifier {
  String? token;
  Map<String, dynamic>? user;
  bool isCheckingSession = true;

  bool get isLoggedIn => token != null && token!.isNotEmpty;

  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    final userString = prefs.getString('user');
    if (userString != null) {
      user = jsonDecode(userString) as Map<String, dynamic>;
    }
    isCheckingSession = false;
    notifyListeners();
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiClient.baseUrl}/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode >= 400) {
      throw Exception(data['message'] ?? 'Login failed');
    }

    await _saveSession(data);
  }

  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiClient.baseUrl}/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode >= 400) {
      throw Exception(data['message'] ?? 'Signup failed');
    }

    await _saveSession(data);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    token = null;
    user = null;
    notifyListeners();
  }

  Future<void> _saveSession(Map<String, dynamic> data) async {
    token = data['token']?.toString();
    user = data['user'] as Map<String, dynamic>?;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token ?? '');
    await prefs.setString('user', jsonEncode(user ?? {}));
    notifyListeners();
  }
}
