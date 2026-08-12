import 'package:dummyjson/screen/cart_screen.dart';
import 'package:dummyjson/screen/product_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
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
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Products"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
        ],
        onTap: (index){
          setState(() {
                      _currentIndex = index;
                    });
        },
      ),
    );
  }
}
