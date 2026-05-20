import 'dart:async';
import 'package:flutter/material.dart';
import '../services/cart_service.dart';
import '../models/cart_item_model.dart';

class CartProvider with ChangeNotifier {
  final CartService _cartService = CartService();
  String? _uid;
  StreamSubscription? _cartSub;

  List<CartItemModel> _items = [];
  List<CartItemModel> get items => _items;

  double get subtotal => _items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  double get shipping => _items.isEmpty ? 0 : (subtotal > 200 ? 0 : 15.0);
  double get total => subtotal + shipping;

  void updateUid(String? uid) {
    if (_uid == uid) return;
    _uid = uid;
    
    _cartSub?.cancel();
    _cartSub = null;
    
    if (_uid != null) {
      _listenToCart();
    } else {
      _items = [];
      notifyListeners();
    }
  }

  void _listenToCart() {
    if (_uid == null) return;
    _cartSub = _cartService.getCartItems(_uid!).listen((items) {
      _items = items;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _cartSub?.cancel();
    super.dispose();
  }

  Future<void> addToCart(CartItemModel item) async {
    if (_uid == null) throw Exception('User not logged in');
    await _cartService.addToCart(_uid!, item);
  }

  Future<void> updateQuantity(String itemId, int quantity) async {
    if (_uid == null) return;
    await _cartService.updateQuantity(_uid!, itemId, quantity);
  }

  Future<void> removeItem(String itemId) async {
    if (_uid == null) return;
    await _cartService.removeItem(_uid!, itemId);
  }

  Future<void> clearCart() async {
    if (_uid == null) return;
    await _cartService.clearCart(_uid!);
  }
}
