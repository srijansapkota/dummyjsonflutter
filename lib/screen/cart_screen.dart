import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/cart_service.dart';
import '../model/cart_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Cart? cart;

  @override
  void initState() {
    super.initState();
    fetchCart();
  }

  Future<void> fetchCart() async {
    final authService = context.read<AuthService>();

    final userId = authService.id;

  if (userId == null) {
    return;
  }
  
    final result = await CartService().fetchCart(userId);

    setState(() {
      cart = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
      ),
      body: cart == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: cart!.products.length,
              itemBuilder: (context, index) {
                final product = cart!.products[index];

                return ListTile(
                  title: Text(product.title),
                  subtitle: Text("Quantity: ${product.quantity}"),
                  trailing: Text("\$${product.price}"),
                );
              },
            ),
    );
  }
}