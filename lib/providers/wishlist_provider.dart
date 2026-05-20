import 'dart:async';
import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../services/product_service.dart';
import '../models/product_model.dart';

class WishlistProvider with ChangeNotifier {
  final UserService _userService = UserService();
  final ProductService _productService = ProductService();
  
  List<String> _wishlistIds = [];
  List<String> get wishlistIds => _wishlistIds;

  String? _currentUid;
  StreamSubscription? _wishlistSub;

  void init(String? uid) {
    if (uid == null) {
      clear();
      return;
    }

    // Prevent re-subscribing if UID hasn't changed
    if (_currentUid == uid) return;
    _currentUid = uid;

    // Cancel any existing subscription
    _wishlistSub?.cancel();

    _wishlistSub = _userService.getWishlist(uid).listen((ids) {
      _wishlistIds = ids;
      notifyListeners();
    });
  }

  void clear() {
    _currentUid = null;
    _wishlistSub?.cancel();
    _wishlistSub = null;
    _wishlistIds = [];
    notifyListeners();
  }

  bool isInWishlist(String productId) {
    return _wishlistIds.contains(productId);
  }

  Future<void> toggleWishlist(String uid, String productId) async {
    // Optimistic Update
    final wasInWishlist = _wishlistIds.contains(productId);
    if (wasInWishlist) {
      _wishlistIds.remove(productId);
    } else {
      _wishlistIds.add(productId);
    }
    notifyListeners();

    try {
      await _userService.toggleWishlist(uid, productId);
    } catch (e) {
      // Rollback on error
      if (wasInWishlist) {
        if (!_wishlistIds.contains(productId)) _wishlistIds.add(productId);
      } else {
        _wishlistIds.remove(productId);
      }
      notifyListeners();
      rethrow;
    }
  }

  Stream<List<ProductModel>> getWishlistProducts() {
    return _productService.getProductsByIds(_wishlistIds);
  }

  @override
  void dispose() {
    _wishlistSub?.cancel();
    super.dispose();
  }
}
