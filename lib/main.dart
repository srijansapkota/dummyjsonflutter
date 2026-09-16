import 'package:dummyjson/screen/login_screen.dart';
import 'package:dummyjson/screen/main_screen.dart';
import 'package:dummyjson/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final service = AuthService();
        service.tryAutoLogin();
        return service;
      },
      child: MaterialApp(
        title: 'Dummy Json with Flutter',
        debugShowCheckedModeBanner: false,
        home: const AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();

    if (authService.isCheckingAuth) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return authService.isAuthenticated
        ? const MainScreen()
        : const LoginScreen();
  }
}
