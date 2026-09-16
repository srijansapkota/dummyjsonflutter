import 'package:dummyjson/model/data_model.dart';
import 'package:dummyjson/services/product_service.dart';

class ProductController {
  final ProductService _productService = ProductService();
  
  List<Product> _products = [];
  bool _isLoading = false;
  bool _hasError = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _skip = 0;
  final int _limit = 10;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;

  Future<void> fetchProducts() async {
    _isLoading = true;
    _hasError = false;

    try {
      final products = await _productService.fetchProducts(
        limit: _limit,
        skip: _skip,
      );
      _products = products;
      _hasError = false;
    } catch (e) {
      _hasError = true;
    } finally {
      _isLoading = false;
    }
  }

  Future<void> loadMoreProducts() async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;

    try {
      final newProducts = await _productService.fetchProducts(
        limit: _limit,
        skip: _skip + _limit,
      );
      _products.addAll(newProducts);
      _skip += _limit;
      if (newProducts.length < _limit) {
        _hasMore = false;
      }
    } catch (e) {
      print(e);
    } finally {
      _isLoadingMore = false;
    }
  }

  void reset() {
    _products = [];
    _skip = 0;
    _hasMore = true;
    _isLoading = false;
    _hasError = false;
    _isLoadingMore = false;
  }
}