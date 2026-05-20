import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Get user profile stream
  Stream<UserModel?> getUserProfile(String uid) {
    return _db.collection('users').doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return UserModel.fromMap(snapshot.data() as Map<String, dynamic>, snapshot.id);
      }
      return null;
    });
  }

  // Update profile image
  Future<String> uploadProfileImage(String uid, File imageFile) async {
    final ref = _storage.ref().child('users').child(uid).child('profile.jpg');
    await ref.putFile(imageFile);
    final url = await ref.getDownloadURL();
    
    await _db.collection('users').doc(uid).update({
      'profileImage': url,
    });
    
    return url;
  }

  // Wishlist methods
  Future<void> toggleWishlist(String uid, String productId) async {
    final userRef = _db.collection('users').doc(uid);
    final wishlistRef = userRef.collection('wishlist').doc(productId);
    
    final doc = await wishlistRef.get();
    if (doc.exists) {
      await wishlistRef.delete();
    } else {
      await wishlistRef.set({
        'productId': productId,
        'addedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Stream<List<String>> getWishlist(String uid) {
    return _db.collection('users').doc(uid).collection('wishlist').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.id).toList();
    });
  }
}
