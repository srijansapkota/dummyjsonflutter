import 'package:dummyjson/model/data_model.dart';
import 'package:dummyjson/services/product_service.dart';
import 'package:dummyjson/widget/product_card.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});
  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductService _productService = ProductService();
  List<Product> _products = [];
  bool _isLoading = false;
  bool _hasError = false;
  final ScrollController _scrollController = ScrollController();
  final int _limit = 10;
  int _skip = 0;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_hasMore &&
        !_isLoadingMore &&
        _scrollController.position.maxScrollExtent -
                _scrollController.position.pixels <
            200) {
      _loadMoreProducts();
    }
  }

  Future<void> _loadMoreProducts() async {
    setState(() {
      _isLoadingMore = true;
    });

    try {
      final newProducts = await _productService.fetchProducts(
        limit: _limit,
        skip: _limit + _skip,
      );
      setState(() {
        _products.addAll(newProducts);
        _skip += _limit;
        if (newProducts.length < _limit) {
          _hasMore = false;
        }
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final products = await _productService.fetchProducts(
        limit: _limit,
        skip: _skip,
      );
      setState(() {
        _products = products;
        _hasError = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyContent;
    if (_isLoading) {
      bodyContent = const Center(child: CircularProgressIndicator());
    } else if (_hasError) {
      bodyContent = const Center(child: Text("Something went wrong"));
    } else {
      bodyContent = GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.65,
        ),
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return ProductCard(product: product,);
        },
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dummy Json Product Fetch",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: [IconButton(onPressed: () => {}, icon: Icon(Icons.search))],
      ),
      body: SafeArea(child: bodyContent),
    );
  }
}
