import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'cart.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/review_section.dart';
import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../providers/wishlist_provider.dart';
import '../providers/auth_provider.dart';
import '../models/cart_item_model.dart';

class MenDetailsPage extends StatefulWidget {
  final Map<String, dynamic> product;
  const MenDetailsPage({super.key, required this.product});

  @override
  State<MenDetailsPage> createState() => _MenDetailsPageState();
}

class _MenDetailsPageState extends State<MenDetailsPage> {
  String _selectedSize = 'M';
  final List<String> _sizes = ['S', 'M', 'L', 'XL'];
  final String _selectedColor = 'Default';

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
    const Color primaryColor = Color(0xFF387B40);
    final String imagePath = widget.product['imagePath'] ?? '';
    final bool isNetworkImage = imagePath.startsWith('http');

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.55,
            child: Container(
              color: Colors.white,
              child: isNetworkImage
                  ? Image.network(
                      imagePath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Center(
                        child: Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
                      ),
                    )
                  : Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Center(
                        child: Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
                      ),
                    ),
            ),
          ),

          // Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomBackButton(
                      backgroundColor: Colors.white,
                      iconColor: Colors.black,
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
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  shape: BoxShape.circle,
                                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
                                ),
                                child: Icon(
                                  isWishlisted ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                                  color: isWishlisted ? Colors.red : Colors.black,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CartPage())),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              shape: BoxShape.circle,
                              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
                            ),
                            child: const Icon(CupertinoIcons.cart_fill, color: primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Details Sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.48,
              padding: const EdgeInsets.fromLTRB(28, 36, 28, 0),
              decoration: const BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.zero,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (widget.product.containsKey('brand'))
                                  Text(
                                    widget.product['brand']!,
                                    style: const TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                Text(
                                  widget.product['name']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Georgia',
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              widget.product['price']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'Georgia',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        const Text(
                          'Select Size',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: _sizes.map((size) {
                            bool isSelected = size == _selectedSize;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedSize = size),
                              child: Container(
                                margin: const EdgeInsets.only(right: 16),
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.white : Colors.white24,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    size,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected ? primaryColor : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Description',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.product['description'] ?? 'This premium product from our Men\'s Collection combines comfort with style. Made from high-quality fabric, it is designed for the modern man who values durability and aesthetics.',
                          style: const TextStyle(color: Colors.white70, fontSize: 15, height: 1.6),
                        ),
                        const SizedBox(height: 24),
                        _buildInfoRow(Icons.local_shipping_outlined, "Delivery in 20 working days"),
                        const SizedBox(height: 12),
                        _buildInfoRow(Icons.assignment_return_outlined, "Return within 7 days"),
                        const SizedBox(height: 30),
                        const Divider(color: Colors.white24),
                        const SizedBox(height: 10),
                        Theme(
                          data: Theme.of(context).copyWith(
                            textTheme: Theme.of(context).textTheme.apply(
                              bodyColor: Colors.white,
                              displayColor: Colors.white,
                            ),
                          ),
                          child: ReviewSection(
                            productId: widget.product['id'] ?? widget.product['name']!,
                            productName: widget.product['name']!,
                            productImage: widget.product['imagePath']!,
                            themeColor: Colors.white,
                            showAddReview: false,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0, top: 12),
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
                            selectedSize: _selectedSize,
                            selectedColor: _selectedColor,
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
                              SnackBar(content: Text('Failed: $e')),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('Add to Cart', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
