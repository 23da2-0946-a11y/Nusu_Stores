import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_item_model.dart';
import 'order_status.dart';

class OrderModel {
  final String orderId;
  final String userId;
  final List<CartItemModel> items;
  final double totalAmount;
  final String status;
  final DateTime createdAt;
  final DateTime deliveryDate;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    required this.deliveryDate,
  });

  factory OrderModel.fromMap(Map<String, dynamic> data, String orderId) {
    return OrderModel(
      orderId: orderId,
      userId: data['userId'] ?? '',
      items: (data['items'] as List? ?? [])
          .map((item) => CartItemModel.fromMap(Map<String, dynamic>.from(item), ''))
          .toList(),
      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
      status: data['status'] ?? OrderStatus.processing,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      deliveryDate: (data['deliveryDate'] as Timestamp?)?.toDate() ?? 
          DateTime.now().add(const Duration(days: 20)),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'status': status,
      'createdAt': createdAt,
      'deliveryDate': deliveryDate,
    };
  }
}
