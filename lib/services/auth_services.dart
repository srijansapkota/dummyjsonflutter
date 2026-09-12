import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/login_model.dart';

class AuthService {
  Future<LoginModel> login({
    required String username,
    required String password,
  }) async {
    final parsedUrl = Uri.https("dummyjson.com", "/auth/login");

    final response = await http.post(
      parsedUrl,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
        "expiresInMins": 30,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Login failed: invalid username or password");
    }

    final decoded = jsonDecode(response.body);
    return LoginModel.fromJson(decoded);
  }
}