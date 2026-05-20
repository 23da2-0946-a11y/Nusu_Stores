import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cart_item_model.dart';

class CartService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get cart items stream
  Stream<List<CartItemModel>> getCartItems(String uid) {
    return _db.collection('carts').doc(uid).collection('items').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return CartItemModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Add to cart
  Future<void> addToCart(String uid, CartItemModel item) async {
    // Check if item already exists with same size and color
    final existingItems = await _db.collection('carts').doc(uid).collection('items')
        .where('productId', isEqualTo: item.productId)
        .where('selectedSize', isEqualTo: item.selectedSize)
        .where('selectedColor', isEqualTo: item.selectedColor)
        .get();

    if (existingItems.docs.isNotEmpty) {
      // Update quantity
      await existingItems.docs.first.reference.update({
        'quantity': FieldValue.increment(item.quantity),
      });
    } else {
      // Add new item
      await _db.collection('carts').doc(uid).collection('items').add(item.toMap());
    }
  }

  // Update quantity
  Future<void> updateQuantity(String uid, String itemId, int quantity) async {
    if (quantity <= 0) {
      await removeItem(uid, itemId);
    } else {
      await _db.collection('carts').doc(uid).collection('items').doc(itemId).update({
        'quantity': quantity,
      });
    }
  }

  // Remove item
  Future<void> removeItem(String uid, String itemId) async {
    await _db.collection('carts').doc(uid).collection('items').doc(itemId).delete();
  }

  // Clear cart atomically
  Future<void> clearCart(String uid) async {
    final items = await _db.collection('carts').doc(uid).collection('items').get();
    if (items.docs.isEmpty) return;

    final WriteBatch batch = _db.batch();
    for (var doc in items.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
