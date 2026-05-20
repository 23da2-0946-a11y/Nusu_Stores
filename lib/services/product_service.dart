import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Stream of products with optional category and subcategory filtering
  Stream<List<ProductModel>> getProducts({String? category, String? subCategory}) {
    Query<Map<String, dynamic>> query = _db.collection('products');
    
    if (category != null && category.toLowerCase() != 'all') {
      query = query.where('category', isEqualTo: category.toLowerCase());
    }

    if (subCategory != null && subCategory.toLowerCase() != 'all') {
      query = query.where('subCategory', isEqualTo: subCategory.toLowerCase());
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProductModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Get products by subcategory
  Stream<List<ProductModel>> getProductsBySubCategory(String category, String subCategory) {
    Query<Map<String, dynamic>> query = _db.collection('products')
        .where('category', isEqualTo: category.toLowerCase());
    
    if (subCategory.toLowerCase() != 'all') {
      query = query.where('subCategory', isEqualTo: subCategory.toLowerCase());
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProductModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Get trending products
  Stream<List<ProductModel>> getTrendingProducts() {
    return _db.collection('products')
        .where('isTrending', isEqualTo: true)
        .limit(10)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProductModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Get Bag category special queries
  Stream<List<ProductModel>> getBagProducts(String filter) {
    Query<Map<String, dynamic>> query = _db.collection('products').where('category', isEqualTo: 'bag');
    
    if (filter == 'Recent') {
      query = query.orderBy('createdAt', descending: true);
    } else if (filter == 'Most viewed') {
      query = query.orderBy('views', descending: true);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProductModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Increment views
  Future<void> incrementViews(String productId) async {
    await _db.collection('products').doc(productId).update({
      'views': FieldValue.increment(1),
    });
  }

  // Get products by a list of IDs (for wishlist)
  Stream<List<ProductModel>> getProductsByIds(List<String> ids) {
    if (ids.isEmpty) return Stream.value([]);
    
    // Firestore whereIn has a limit of 10-30 items depending on version.
    // For a larger wishlist, we would need to batch this.
    return _db.collection('products')
        .where(FieldPath.documentId, whereIn: ids)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ProductModel.fromMap(doc.data(), doc.id)).toList();
    });
  }
}
