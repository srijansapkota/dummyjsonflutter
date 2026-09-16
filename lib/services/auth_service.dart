import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../model/login_model.dart';

class AuthService extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();

  static const _accessTokenKey = 'accessToken';
  static const _refreshTokenKey = 'refreshToken';

  int? id;
  String? username;
  String? accessToken;
  bool isAuthenticated = false;

  bool isLoading = false;
  String? errorMessage;

  bool isCheckingAuth = true;

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    http.Response response;
    try {
      final url = Uri.https("dummyjson.com", "/auth/login");
      response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "password": password,
          "expiresInMins": 30,
        }),
      );
    } catch (e) {
      isLoading = false;
      errorMessage = "Couldn't reach the server. Check your connection.";
      notifyListeners();
      return false;
    }

    if (response.statusCode == 401) {
      isLoading = false;
      errorMessage = "Invalid username or password";
      notifyListeners();
      return false;
    }

    if (response.statusCode != 200) {
      isLoading = false;
      errorMessage = "Server error (${response.statusCode}). Please try again.";
      notifyListeners();
      return false;
    }

    try {
      final loginModel = LoginModel.fromJson(jsonDecode(response.body));

      this.id = loginModel.id;
      this.username = loginModel.username;
      this.accessToken = loginModel.accessToken;
      this.isAuthenticated = true;

      await _storage.write(key: _accessTokenKey, value: loginModel.accessToken);
      await _storage.write(key: _refreshTokenKey, value: loginModel.refreshToken);

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      errorMessage = "Something went wrong on our end. This is a bug, not a login problem.";
      debugPrint("Login succeeded but parsing/storage failed: $e");
      notifyListeners();
      return false;
    }
  }

  Future<void> tryAutoLogin() async {
    final savedToken = await _storage.read(key: _accessTokenKey);
    if (savedToken != null) {
      accessToken = savedToken;
      isAuthenticated = true;
    }
    isCheckingAuth = false;
    notifyListeners();
  }

  Future<void> logout() async {
    id = null;
    username = null;
    accessToken = null;
    isAuthenticated = false;

    await _storage.deleteAll();
    notifyListeners();
  }
}
