import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dummyjson/model/cart_model.dart';

class CartService {
  Future<Cart?> fetchCart(int userId) async {
    final response = await http.get(
      Uri.parse("https://dummyjson.com/carts/user/$userId"),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final cartModel = CartModel.fromJson(data);
      if (cartModel.carts.isNotEmpty) {
        return cartModel.carts[0];
      }
    }
    return null;
  }
}
