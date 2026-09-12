import 'package:dummyjson/services/auth_services.dart';
import '../services/auth_provider.dart';

class LoginController {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  String? errorMessage;

  Future<bool> login({
    required String username,
    required String password,
    required AuthProvider authProvider,
  }) async {
    isLoading = true;
    errorMessage = null;

    try {
      final loginModel = await _authService.login(
        username: username,
        password: password,
      );
      await authProvider.login(loginModel);
      isLoading = false;
      return true;
    } catch (e) {
      errorMessage = "Invalid username or password";
      isLoading = false;
      return false;
    }
  }
}