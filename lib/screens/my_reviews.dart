import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../services/firestore_service.dart';
import '../widgets/custom_header.dart';
import 'women_details.dart';
import 'men_details.dart';
import 'bag_details.dart';

class MyReviewsPage extends StatelessWidget {
  const MyReviewsPage({super.key});

  Map<String, dynamic> _getProductDetails(String productName) {
    final Map<String, Map<String, dynamic>> products = {
      'Floral Midi Dress': {'brand': 'H&M', 'price': 'Rs. 150', 'imagePath': 'lib/assets/images/women category/top/38.png', 'type': 'women'},
      'Stylish Cap': {'brand': 'Mango', 'price': 'Rs. 450', 'imagePath': 'lib/assets/images/women category/top/37.png', 'type': 'women'},
      'Leather Shoes': {'brand': 'Aldo', 'price': 'Rs. 350', 'imagePath': 'lib/assets/images/women category/shoes/32.png', 'type': 'women'},
      'Casual Pants': {'brand': 'Zara', 'price': 'Rs. 750', 'imagePath': 'lib/assets/images/women category/pants/24.jpg', 'type': 'women'},
      
      'Slim Fit Shirt': {'brand': 'Bossy', 'price': 'Rs.850', 'imagePath': 'lib/assets/images/men category/shirts/shirt.png', 'type': 'men'},
      'Casual Trousers': {'brand': 'Mango', 'price': 'Rs450', 'imagePath': 'lib/assets/images/men category/pants/13.png', 'type': 'men'},
      'Baseball Cap': {'brand': 'Aldo', 'price': 'Rs.350', 'imagePath': 'lib/assets/images/men category/caps/cap.png', 'type': 'men'},
      'Denim Jacket': {'brand': 'Zara', 'price': 'Rs750', 'imagePath': 'lib/assets/images/men category/shirts/14.jpg', 'type': 'men'},

      'Laptop\nBags': {'brand': 'Nusu', 'price': 'Rs.150', 'imagePath': 'lib/assets/images/bag category/bages.png', 'type': 'bag'},
      'Clothing\nBags': {'brand': 'Nusu', 'price': 'Rs.250', 'imagePath': 'lib/assets/images/bag category/d.png', 'type': 'bag'},
      'School\nBags': {'brand': 'Nusu', 'price': 'Rs.150', 'imagePath': 'lib/assets/images/bag category/bages girl.png', 'type': 'bag'},
      'Child\nBags': {'brand': 'Nusu', 'price': 'Rs.150', 'imagePath': 'lib/assets/images/bag category/bag.png', 'type': 'bag'},
    };

    return products[productName] ?? {'brand': 'Nusu', 'price': 'Rs. 0', 'imagePath': 'lib/assets/images/icon/mlah_launcher.jpeg', 'type': 'women'};
  }

  void _navigateToProduct(BuildContext context, String productName) {
    final details = _getProductDetails(productName);
    final productMap = {
      'name': productName,
      'price': details['price'] as String,
      'imagePath': details['imagePath'] as String,
      'brand': details['brand'] as String,
    };

    Widget targetPage;
    if (details['type'] == 'men') {
      targetPage = MenDetailsPage(product: productMap);
    } else if (details['type'] == 'bag') {
      targetPage = BagDetailsPage(product: productMap);
    } else {
      targetPage = WomenDetailsPage(product: productMap);
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => targetPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF387B40);
    const Color lightGreen = Color(0xFF8CC18D);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.grey.shade400],
            stops: const [0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const CustomHeader(title: 'My Reviews'),
              Expanded(
                child: user == null
                    ? const Center(
                        child: Text(
                          'Please login to view your reviews',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                      )
                    : StreamBuilder<QuerySnapshot>(
                        stream: FirestoreService().getUserReviews(user.uid),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(color: primaryColor),
                            );
                          }

                          if (snapshot.hasError) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(40),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.error_outline,
                                        size: 60,
                                        color: lightGreen.withValues(alpha: 0.5)),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'Unable to load reviews',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                        fontFamily: 'Georgia',
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Please check your connection\nand try again',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.rate_review_outlined,
                                      size: 80,
                                      color: lightGreen.withValues(alpha: 0.5)),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'No reviews yet',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Georgia',
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Your product reviews will\nappear here',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          final reviews = snapshot.data!.docs.toList();
                          
                          // Sort locally to bypass Firestore composite index requirements
                          reviews.sort((a, b) {
                            final aData = a.data() as Map<String, dynamic>;
                            final bData = b.data() as Map<String, dynamic>;
                            final aTime = aData['timestamp'] as Timestamp?;
                            final bTime = bData['timestamp'] as Timestamp?;
                            if (aTime == null && bTime == null) return 0;
                            if (aTime == null) return 1;
                            if (bTime == null) return -1;
                            return bTime.compareTo(aTime); // Descending order
                          });

                          return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            itemCount: reviews.length,
                            itemBuilder: (context, index) {
                              final review =
                                  reviews[index].data() as Map<String, dynamic>;
                              final int rating = review['rating'] ?? 0;
                              final String comment = review['comment'] ?? '';
                              final timestamp =
                                  review['timestamp'] as Timestamp?;
                              final date = timestamp != null
                                  ? DateFormat('dd MMM yyyy')
                                      .format(timestamp.toDate())
                                  : '';

                              // Get the product name from the parent document path
                              final String productId = review['productId'] ?? '';
                              final String productName = review['productName'] ?? 'Product';
                              final String productImage = review['productImage'] ?? '';

                              return _buildReviewCard(
                                context: context,
                                productId: productId,
                                productName: productName,
                                productImage: productImage,
                                reviewId: reviews[index].id,
                                rating: rating,
                                comment: comment,
                                date: date,
                                primaryColor: primaryColor,
                                lightGreen: lightGreen,
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewCard({
    required BuildContext context,
    required String productId,
    required String productName,
    required String productImage,
    required String reviewId,
    required int rating,
    required String comment,
    required String date,
    required Color primaryColor,
    required Color lightGreen,
  }) {
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: lightGreen, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _navigateToProduct(context, productName),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      productImage.isNotEmpty ? productImage : 'lib/assets/images/icon/mlah_launcher.jpeg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => 
                        const Icon(Icons.image_not_supported, color: Colors.grey, size: 40),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Review Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product name + date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              productName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                                fontFamily: 'Georgia',
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (date.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                                  onPressed: () => _handleDeleteReview(context, productName, reviewId),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: lightGreen.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    date,
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Star rating
                      Row(
                        children: List.generate(5, (i) {
                          return Icon(
                            i < rating
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            color: Colors.amber,
                            size: 18,
                          );
                        }),
                      ),
                      const SizedBox(height: 8),

                      // Comment
                      Text(
                        comment,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _handleDeleteReview(BuildContext context, String productId, String reviewId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Review', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to delete this review?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Yes')),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await FirebaseFirestore.instance
            .collection('reviews')
            .doc(reviewId)
            .delete();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Review deleted successfully')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }
}
