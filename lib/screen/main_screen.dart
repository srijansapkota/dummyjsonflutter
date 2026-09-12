import 'package:dummyjson/screen/cart_screen.dart';
import 'package:dummyjson/screen/login_screen.dart';
import 'package:dummyjson/screen/product_screen.dart';
import 'package:dummyjson/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  Future<void> _logout() async {
    await context.read<AuthProvider>().logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (_currentIndex == 0) {
      body = ProductScreen();
    } else if (_currentIndex == 1) {
      body = CartScreen();
    } else {
      body = ProductScreen();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dummy Json with Flutter"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: "Log out",
          ),
        ],
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Products"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
        ],
        selectedItemColor: Colors.amber[800],
        onTap: (index){
          setState(() {
                      _currentIndex = index;
                    });
        },
      ),
    );
  }
}