import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'men_details.dart';
import '../widgets/custom_header.dart';
import '../providers/product_provider.dart';
import '../models/product_model.dart';
import '../providers/auth_provider.dart';
import '../providers/wishlist_provider.dart';
import 'package:flutter/cupertino.dart';

class MenProductPage extends StatefulWidget {
  const MenProductPage({super.key});

  @override
  State<MenProductPage> createState() => _MenProductPageState();
}

class _MenProductPageState extends State<MenProductPage> {
  String _selectedSubCategory = 'All';

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF387B40);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F5),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomHeader(title: "Men's Collection"),
              const SizedBox(height: 10),
              
              // Category Pills
              SizedBox(
                height: 38,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  children: [
                    _buildPill('All', _selectedSubCategory == 'All', primaryColor),
                    _buildPill('Shirt', _selectedSubCategory == 'Shirt', primaryColor),
                    _buildPill('Pants', _selectedSubCategory == 'Pants', primaryColor),
                    _buildPill('T-Shirt', _selectedSubCategory == 'T-Shirt', primaryColor),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Product List
              Expanded(
                child: Consumer<ProductProvider>(
                  builder: (context, productProvider, child) {
                    return StreamBuilder<List<ProductModel>>(
                      stream: productProvider.getProducts('Men', subCategory: _selectedSubCategory == 'All' ? null : _selectedSubCategory.toLowerCase()),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator(color: primaryColor));
                        }
                        
                        final products = snapshot.data ?? [];
                        
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                '${products.length} items found',
                                style: const TextStyle(
                                  color: primaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Georgia',
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: GridView.builder(
                                  itemCount: products.length,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: 0.72,
                                  ),
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return _buildProductCard(products[index]);
                                  },
                                ),
                              ),
                            ),
                          ],
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

  Widget _buildPill(String label, bool isSelected, Color primaryColor) {
    return GestureDetector(
      onTap: () => setState(() => _selectedSubCategory = label),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(ProductModel product) {
    final String imagePath = product.images.isNotEmpty ? product.images[0] : '';
    final bool isNetworkImage = imagePath.startsWith('http');

    return GestureDetector(
      onTap: () {
        context.read<ProductProvider>().viewProduct(product.id);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MenDetailsPage(
              product: {
                'id': product.id,
                'name': product.name,
                'price': 'Rs.${product.price}',
                'imagePath': imagePath,
                'description': product.description,
              },
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF387B40),
          borderRadius: BorderRadius.circular(16),
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
                      width: double.infinity,
                      color: Colors.white,
                      child: isNetworkImage
                        ? Image.network(imagePath, fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.image))
                        : Image.asset(imagePath, fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.image)),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Consumer2<WishlistProvider, AuthProvider>(
                      builder: (context, wishlist, auth, child) {
                        final isWishlisted = wishlist.isInWishlist(product.id);
                        return GestureDetector(
                          onTap: () {
                            final uid = auth.uid;
                            if (uid != null) {
                              wishlist.toggleWishlist(uid, product.id);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isWishlisted ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                              size: 18,
                              color: isWishlisted ? Colors.red : Colors.grey,
                            ),
                          ),
                        );
                      },
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Men',
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Georgia',
                            fontSize: 14,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Georgia',
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        'Rs.${product.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Georgia',
                          fontSize: 18,
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
