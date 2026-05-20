import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'cart.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/review_section.dart';
import '../theme/app_colors.dart';
import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../providers/wishlist_provider.dart';
import '../providers/auth_provider.dart';
import '../models/cart_item_model.dart';

class BagDetailsPage extends StatefulWidget {
  final Map<String, dynamic> product;
  const BagDetailsPage({super.key, required this.product});

  @override
  State<BagDetailsPage> createState() => _BagDetailsPageState();
}

class _BagDetailsPageState extends State<BagDetailsPage> {
  @override
  void initState() {
    super.initState();
    _incrementProductViews();
  }

  Future<void> _incrementProductViews() async {
    final productId = widget.product['id'];
    if (productId != null) {
      await context.read<ProductProvider>().viewProduct(productId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String imagePath = widget.product['imagePath'] ?? '';
    final bool isNetworkImage = imagePath.startsWith('http');

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.backgroundGradient,
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                
                // Product Image
                Expanded(
                  flex: 5,
                  child: Center(
                    child: Hero(
                      tag: widget.product['id'] ?? widget.product['name']!,
                      child: isNetworkImage
                        ? Image.network(imagePath, fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.image))
                        : Image.asset(imagePath, fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.image)),
                    ),
                  ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack).fadeIn(),
                ),

                // Details Section
                Expanded(
                  flex: 6,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(30, 40, 30, 20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 20,
                          offset: Offset(0, -10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.product['name']!,
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            Text(
                              widget.product['price']!,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Expanded(
                          child: ListView(
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.zero,
                            children: [
                              Text(
                                'Product Description',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                widget.product['description'] ?? 'This premium luggage item combines durability with a sleek, modern design. Perfect for both business trips and leisure travel, it features high-quality materials and thoughtful organization compartments.',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AppColors.textSecondary,
                                  height: 1.6,
                                ),
                              ),
                              const SizedBox(height: 24),
                              _buildInfoRow(Icons.local_shipping_outlined, "Delivery in 20 working days"),
                              const SizedBox(height: 12),
                              _buildInfoRow(Icons.assignment_return_outlined, "Return within 7 days"),
                              const SizedBox(height: 32),
                              const Divider(height: 1, color: AppColors.background),
                              const SizedBox(height: 24),
                                ReviewSection(
                                  productId: widget.product['id'] ?? widget.product['name']!,
                                  productName: widget.product['name']!,
                                  productImage: widget.product['imagePath']!,
                                  themeColor: AppColors.primary,
                                  showAddReview: false,
                                ),
                              const SizedBox(height: 100), // Space for button
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate().slideY(begin: 0.2, end: 0, duration: 500.ms, curve: Curves.easeOutCubic),
                ),
              ],
            ),
          ),
          
          // Sticky Bottom Button
          Positioned(
            left: 30,
            right: 30,
            bottom: 40,
            child: ElevatedButton(
              onPressed: () async {
                try {
                  final cartProvider = context.read<CartProvider>();
                  final priceStr = widget.product['price']!.replaceAll('Rs.', '').trim();
                  final price = double.tryParse(priceStr) ?? 0.0;
                  
                  await cartProvider.addToCart(CartItemModel(
                    itemId: '',
                    productId: widget.product['id'] ?? widget.product['name']!,
                    quantity: 1,
                    selectedSize: 'One Size',
                    selectedColor: 'Default',
                    price: price,
                    productName: widget.product['name']!,
                    productImage: widget.product['imagePath']!,
                  ));

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Added to cart!')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to add: $e')),
                    );
                  }
                }
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.bag_badge_plus),
                  SizedBox(width: 12),
                  Text('Add to Cart'),
                ],
              ),
            ).animate().slideY(begin: 1, end: 0, delay: 600.ms),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CustomBackButton(
            backgroundColor: Colors.white,
            iconColor: AppColors.textPrimary,
            size: 20,
          ),
          Row(
            children: [
              Consumer2<WishlistProvider, AuthProvider>(
                builder: (context, wishlist, auth, child) {
                  final productId = widget.product['id'] ?? '';
                  final isWishlisted = wishlist.isInWishlist(productId);
                  return GestureDetector(
                    onTap: () {
                      final uid = auth.uid;
                      if (uid != null && productId.isNotEmpty) {
                        wishlist.toggleWishlist(uid, productId);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        isWishlisted ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                        color: isWishlisted ? Colors.red : AppColors.textPrimary,
                        size: 20,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              _buildCircleAction(
                icon: CupertinoIcons.cart,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CartPage())),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCircleAction({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.textPrimary, size: 20),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 12),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
