import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'women_details.dart';
import '../widgets/custom_header.dart';
import '../theme/app_colors.dart';
import '../providers/product_provider.dart';
import '../models/product_model.dart';
import '../providers/auth_provider.dart';
import '../providers/wishlist_provider.dart';
import 'package:flutter/cupertino.dart';

class WomanProductPage extends StatefulWidget {
  const WomanProductPage({super.key});

  @override
  State<WomanProductPage> createState() => _WomanProductPageState();
}

class _WomanProductPageState extends State<WomanProductPage> {
  String _selectedSubCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.backgroundGradient,
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CustomHeader(title: "Women's Collection"),
            const SizedBox(height: 12),
            
            // Category Pills
            SizedBox(
              height: 45,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                children: [
                  _buildCategoryChip('All'),
                  _buildCategoryChip('Shoes'),
                  _buildCategoryChip('Skirts'),
                  _buildCategoryChip('Tops'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Product Grid
            Expanded(
              child: Consumer<ProductProvider>(
                builder: (context, productProvider, child) {
                  return StreamBuilder<List<ProductModel>>(
                    stream: productProvider.getProducts('Women', subCategory: _selectedSubCategory == 'All' ? null : _selectedSubCategory.toLowerCase()),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No products found in this category'));
                      }
                      final products = snapshot.data!;
                      return GridView.builder(
                        itemCount: products.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.7,
                        ),
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return _buildProductCard(products[index]);
                        },
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

  Widget _buildCategoryChip(String label) {
    final isSelected = _selectedSubCategory == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedSubCategory = label),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: isSelected ? [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ] : null,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.textHint.withValues(alpha: 0.2),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textSecondary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
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
            builder: (context) => WomenDetailsPage(
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                      child: isNetworkImage
                        ? Image.network(imagePath, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.image))
                        : Image.asset(imagePath, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.image)),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
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
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isWishlisted ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                              size: 18,
                              color: isWishlisted ? Colors.red : AppColors.textSecondary,
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
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Women',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        height: 1.2,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rs.${product.price}',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.add, color: Colors.white, size: 16),
                        ),
                      ],
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
