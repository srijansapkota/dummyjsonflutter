import 'package:dummyjson/controllers/product_controller.dart';
import 'package:dummyjson/widget/product_card.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});
  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductController _controller = ProductController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchProducts() async {
    await _controller.fetchProducts();
    setState(() {});
  }

  Future<void> _loadMoreProducts() async {
    await _controller.loadMoreProducts();
    setState(() {});
  }

  void _onScroll() {
    if (_controller.hasMore &&
        !_controller.isLoadingMore &&
        _scrollController.position.maxScrollExtent -
                _scrollController.position.pixels <
            200) {
      _loadMoreProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyContent;
    
    if (_controller.isLoading) {
      bodyContent = const Center(child: CircularProgressIndicator());
    } else if (_controller.hasError) {
      bodyContent = const Center(child: Text("Something went wrong"));
    } else if (_controller.products.isEmpty) {
      bodyContent = const Center(child: Text("No products found"));
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
        itemCount: _controller.products.length + 
            (_controller.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _controller.products.length) {
            return const Center(child: CircularProgressIndicator());
          }
          final product = _controller.products[index];
          return ProductCard(product: product);
        },
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Dummy Json Product Fetch",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: SafeArea(child: bodyContent),
    );
  }
}