import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';
import '../models/cart_item_model.dart';
import '../models/order_status.dart';

class OrderService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'orders';

  /// Creates a new order in Firestore with the required fields.
  /// Sets initial status to 'Processing' and delivery date to +20 days.
  Future<String> createOrder(String uid, List<CartItemModel> items, double totalAmount) async {
    try {
      final orderData = {
        'userId': uid,
        'items': items.map((item) => item.toMap()).toList(),
        'totalAmount': totalAmount,
        'status': OrderStatus.processing,
        'createdAt': FieldValue.serverTimestamp(),
        'deliveryDate': Timestamp.fromDate(DateTime.now().add(const Duration(days: 20))),
      };

      final docRef = await _db.collection(_collection).add(orderData);
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  /// Fetches a real-time stream of orders for a specific user.
  /// Ordered by creation date (newest first).
  Stream<List<OrderModel>> getOrders(String uid) {
    return _db.collection(_collection)
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
      final orders = snapshot.docs.map((doc) {
        return OrderModel.fromMap(doc.data(), doc.id);
      }).toList();
      
      // Sort client-side to avoid requiring a Firestore composite index 
      // (which throws errors if not manually created in the Firebase console).
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      return orders;
    });
  }

  /// Updates the status of an existing order.
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    if (!OrderStatus.all.contains(newStatus)) {
      throw Exception('Invalid order status: $newStatus');
    }
    
    try {
      await _db.collection(_collection).doc(orderId).update({
        'status': newStatus,
      });
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }

  /// Helper method to cancel an order atomically.
  /// Validation: Can only cancel if the status is currently 'Processing'.
  Future<void> cancelOrder(String orderId) async {
    final docRef = _db.collection(_collection).doc(orderId);

    try {
      await _db.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);
        if (!snapshot.exists) {
          throw Exception('Order does not exist.');
        }

        final currentStatus = snapshot.data()?['status'] as String?;
        if (currentStatus != OrderStatus.processing) {
          throw Exception('Order can only be cancelled while it is processing. Current status: $currentStatus');
        }

        transaction.update(docRef, {'status': OrderStatus.cancelled});
      });
    } catch (e) {
      throw Exception('Failed to cancel order: $e');
    }
  }

  /// Helper method to return an order atomically.
  /// Validation: Can only return if the status is 'Delivered' and within 7 days.
  Future<void> returnOrder(String orderId) async {
    final docRef = _db.collection(_collection).doc(orderId);

    try {
      await _db.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);
        if (!snapshot.exists) {
          throw Exception('Order does not exist.');
        }

        final data = snapshot.data()!;
        final currentStatus = data['status'] as String?;
        final deliveryDateTimestamp = data['deliveryDate'] as Timestamp?;

        if (currentStatus != OrderStatus.delivered) {
          throw Exception('Only delivered orders can be returned. Current status: $currentStatus');
        }

        if (deliveryDateTimestamp == null) {
          throw Exception('Delivery date is missing from this order.');
        }

        final deliveryDate = deliveryDateTimestamp.toDate();
        final daysSinceDelivery = DateTime.now().difference(deliveryDate).inDays;
        
        if (daysSinceDelivery > 7) {
          throw Exception('Return period (7 days after delivery) has expired.');
        }

        transaction.update(docRef, {'status': OrderStatus.returned});
      });
    } catch (e) {
      throw Exception('Failed to return order: $e');
    }
  }
}
