import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Example: Get user profile data
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      throw Exception('Error fetching user data: $e');
    }
  }

  // Example: Save or update user profile data
  Future<void> saveUserData(String uid, Map<String, dynamic> data) async {
    try {
      await _db.collection('users').doc(uid).set(data, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Error saving user data: $e');
    }
  }

  // Add more methods for handling products, categories, orders, etc.
  
  // --- Orders ---
  Future<void> createOrder(String uid, Map<String, dynamic> orderData) async {
    try {
      await _db.collection('users').doc(uid).collection('orders').add(orderData);
    } catch (e) {
      throw Exception('Error creating order: $e');
    }
  }

  Stream<QuerySnapshot> getOrders(String uid) {
    return _db.collection('users').doc(uid).collection('orders').orderBy('timestamp', descending: true).snapshots();
  }

  // --- Addresses ---
  Future<void> addAddress(String uid, Map<String, dynamic> addressData) async {
    try {
      await _db.collection('users').doc(uid).collection('addresses').add(addressData);
    } catch (e) {
      throw Exception('Error adding address: $e');
    }
  }

  Future<void> updateAddress(String uid, String addressId, Map<String, dynamic> addressData) async {
    try {
      await _db.collection('users').doc(uid).collection('addresses').doc(addressId).update(addressData);
    } catch (e) {
      throw Exception('Error updating address: $e');
    }
  }

  Future<void> deleteAddress(String uid, String addressId) async {
    try {
      await _db.collection('users').doc(uid).collection('addresses').doc(addressId).delete();
    } catch (e) {
      throw Exception('Error deleting address: $e');
    }
  }

  Stream<QuerySnapshot> getAddresses(String uid) {
    return _db.collection('users').doc(uid).collection('addresses').snapshots();
  }

  // --- Payment Methods ---
  Future<void> addPaymentMethod(String uid, Map<String, dynamic> cardData) async {
    try {
      await _db.collection('users').doc(uid).collection('payment_methods').add(cardData);
    } catch (e) {
      throw Exception('Error adding payment method: $e');
    }
  }

  Future<void> deletePaymentMethod(String uid, String methodId) async {
    try {
      await _db.collection('users').doc(uid).collection('payment_methods').doc(methodId).delete();
    } catch (e) {
      throw Exception('Error deleting payment method: $e');
    }
  }

  Stream<QuerySnapshot> getPaymentMethods(String uid) {
    return _db.collection('users').doc(uid).collection('payment_methods').snapshots();
  }

  // --- User Reviews (collection group query across all products) ---
  Stream<QuerySnapshot> getUserReviews(String userId) {
    return _db
        .collection('reviews')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }
}
