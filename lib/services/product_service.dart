import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/product_model.dart';

class ProductService {
  Future<List<Product>> fetchProducts({int limit = 10, int skip = 0}) async {
    final parsedUrl = Uri.https(
      "dummyjson.com",
      "/products",
      {
        "limit": limit.toString(),
        "skip": skip.toString(),
      },
    );
    final productResponse = await http.get(parsedUrl);
    if (productResponse.statusCode != 200) {
      throw Exception("Failed");
    }
    final decodedProducts = jsonDecode(productResponse.body);
    final List<dynamic> productList = decodedProducts['products'];
    return productList.map((item) => Product.fromJson(item)).toList();
  }
}
