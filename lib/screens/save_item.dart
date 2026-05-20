import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'bag_details.dart';
import 'men_details.dart';
import 'women_details.dart';
import '../widgets/custom_header.dart';
import '../providers/wishlist_provider.dart';
import '../providers/auth_provider.dart';
import '../models/product_model.dart';

class SaveItemPage extends StatefulWidget {
  const SaveItemPage({super.key});

  @override
  State<SaveItemPage> createState() => _SaveItemPageState();
}

class _SaveItemPageState extends State<SaveItemPage> {
  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF387B40);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Colors.grey.shade400,
          ],
          stops: const [0.6, 1.0],
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CustomHeader(title: 'Save Items', forceShow: true),
            const SizedBox(height: 32),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Container(
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFF8CC18D), width: 1.5),
                ),
                child: const Row(
                  children: [
                    SizedBox(width: 12),
                    Icon(CupertinoIcons.search, color: Colors.black54, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'search in your save items',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Filter Pills
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildFilterPill('Recent', true, primaryColor),
                  _buildFilterPill('most viwe', false, primaryColor),
                  _buildFilterPill('fevourit', false, primaryColor),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Product Grid - now from Firebase
            Expanded(
              child: Consumer<WishlistProvider>(
                builder: (context, wishlistProvider, child) {
                  if (wishlistProvider.wishlistIds.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.heart, size: 64, color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          Text(
                            'No saved items yet',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap the heart icon on any product to save it',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return StreamBuilder<List<ProductModel>>(
                    stream: wishlistProvider.getWishlistProducts(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator(color: Color(0xFF387B40)));
                      }

                      final products = snapshot.data ?? [];
                      if (products.isEmpty) {
                        return const Center(child: Text('No saved items found'));
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.72,
                          ),
                          padding: const EdgeInsets.only(bottom: 120),
                          physics: const BouncingScrollPhysics(),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            return _buildSavedCard(product: products[index]);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPill(String label, bool isSelected, Color primaryColor) {
    bool isRecent = label == 'Recent';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isRecent ? Colors.white : const Color(0xFF387B40),
        borderRadius: BorderRadius.circular(16),
        border: isRecent ? Border.all(color: const Color(0xFF8CC18D), width: 1) : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isRecent ? const Color(0xFF8CC18D) : Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
          fontFamily: 'Georgia',
        ),
      ),
    );
  }

  Widget _buildSavedCard({required ProductModel product}) {
    final authProvider = context.read<AuthProvider>();
    final wishlistProvider = context.read<WishlistProvider>();
    final String imagePath = product.images.isNotEmpty ? product.images[0] : '';
    final bool isNetworkImage = imagePath.startsWith('http');

    return GestureDetector(
      onTap: () {
        final productMap = {
          'name': product.name,
          'price': 'Rs.${product.price}',
          'imagePath': imagePath,
          'description': product.description,
          'id': product.id,
        };

        if (product.category == 'men') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => MenDetailsPage(product: productMap)));
        } else if (product.category == 'bag') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => BagDetailsPage(product: productMap)));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) => WomenDetailsPage(product: productMap)));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF387B40),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: Container(
                      color: Colors.white,
                      width: double.infinity,
                      child: isNetworkImage
                          ? Image.network(
                              imagePath,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.image, size: 40, color: Colors.grey),
                            )
                          : Image.asset(
                              imagePath,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.image, size: 40, color: Colors.grey),
                            ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        final uid = authProvider.uid;
                        if (uid != null) {
                          wishlistProvider.toggleWishlist(uid, product.id);
                        }
                      },
                      child: const Icon(CupertinoIcons.heart_fill,
                          color: Colors.red, size: 22),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Georgia',
                        fontSize: 17,
                        height: 1.1,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        'Rs.${product.price}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Georgia',
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
