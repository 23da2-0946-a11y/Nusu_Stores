import 'package:flutter/material.dart';
import '../services/product_service.dart';
import '../models/product_model.dart';

class ProductProvider with ChangeNotifier {
  final ProductService _productService = ProductService();

  List<ProductModel> _trendingProducts = [];
  List<ProductModel> get trendingProducts => _trendingProducts;

  ProductProvider() {
    _listenToTrending();
  }

  void _listenToTrending() {
    _productService.getTrendingProducts().listen((products) {
      _trendingProducts = products;
      notifyListeners();
    });
  }

  Stream<List<ProductModel>> getProducts(String category, {String? subCategory}) {
    return _productService.getProducts(category: category, subCategory: subCategory);
  }

  Stream<List<ProductModel>> getProductsBySubCategory(String category, String subCategory) {
    return _productService.getProductsBySubCategory(category, subCategory);
  }

  Stream<List<ProductModel>> getBagProducts(String filter) {
    return _productService.getBagProducts(filter);
  }

  Future<void> viewProduct(String productId) async {
    await _productService.incrementViews(productId);
  }
}
