import 'package:flutter/material.dart';
import '../services/order_service.dart';
import '../models/order_model.dart';
import '../models/cart_item_model.dart';

class OrderProvider with ChangeNotifier {
  final OrderService _orderService = OrderService();
  String? _uid;

  void updateUid(String? uid) {
    _uid = uid;
    notifyListeners();
  }

  Stream<List<OrderModel>> get orders {
    if (_uid == null) return Stream.value([]);
    return _orderService.getOrders(_uid!);
  }

  Future<String> placeOrder(List<CartItemModel> items, double total) async {
    if (_uid == null) throw Exception('User not logged in');
    return await _orderService.createOrder(_uid!, items, total);
  }

  Future<void> cancelOrder(String orderId) async {
    await _orderService.cancelOrder(orderId);
  }

  Future<void> returnOrder(String orderId) async {
    await _orderService.returnOrder(orderId);
  }
}
