import 'package:flutter/foundation.dart';
import '../model/login_model.dart';
import 'token_service.dart';

class AuthProvider extends ChangeNotifier {
  final TokenService _tokenService = TokenService();

  int? id;
  String? username;
  String? accessToken;
  bool isAuthenticated = false;

  Future<void> login(LoginModel loginModel) async {
    id = loginModel.id;
    username = loginModel.username;
    accessToken = loginModel.accessToken;
    isAuthenticated = true;

    await _tokenService.saveAccessToken(loginModel.accessToken);
    await _tokenService.saveRefreshToken(loginModel.refreshToken);

    notifyListeners();
  }

  
  Future<void> tryAutoLogin() async {
    final savedToken = await _tokenService.getAccessToken();
    if (savedToken != null) {
      accessToken = savedToken;
      isAuthenticated = true;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    id = null;
    username = null;
    accessToken = null;
    isAuthenticated = false;

    await _tokenService.deleteAll();
    notifyListeners();
  }
}