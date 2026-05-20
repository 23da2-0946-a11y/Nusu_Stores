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

class WomenDetailsPage extends StatefulWidget {
  final Map<String, dynamic> product;
  const WomenDetailsPage({super.key, required this.product});

  @override
  State<WomenDetailsPage> createState() => _WomenDetailsPageState();
}

class _WomenDetailsPageState extends State<WomenDetailsPage> {
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
    final String imagePath = widget.product['imagePath'] ?? '';
    final bool isNetworkImage = imagePath.startsWith('http');

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Header Image Section
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Container(
              color: const Color(0xFFF0F4F1),
              child: isNetworkImage
                  ? Image.network(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Center(
                        child: Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
                      ),
                    )
                  : Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Center(
                        child: Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
                      ),
                    ),
            ),
          ),
          
          // Header Actions
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomBackButton(
                      backgroundColor: Colors.white,
                      iconColor: Color(0xFF387B40),
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
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isWishlisted ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                                  size: 22,
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
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(CupertinoIcons.cart_fill, size: 22, color: Color(0xFF387B40)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Bottom Details Sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.48,
              padding: const EdgeInsets.fromLTRB(28, 36, 28, 0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -4),
                  )
                ]
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                widget.product['name']!.replaceAll('\n', ' '),
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF276A3D),
                                  fontFamily: 'Georgia',
                                ),
                              ),
                            ),
                            Text(
                              widget.product['price']!,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'Georgia',
                                color: Color(0xFF387B40),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Colors.amber, size: 22),
                            const Icon(Icons.star_rounded, color: Colors.amber, size: 22),
                            const Icon(Icons.star_rounded, color: Colors.amber, size: 22),
                            const Icon(Icons.star_rounded, color: Colors.amber, size: 22),
                            Icon(Icons.star_half_rounded, color: Colors.amber.shade200, size: 22),
                            const SizedBox(width: 8),
                            const Text(
                              '4.8 (120 reviews)',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 28),
                        
                        const Text(
                          'Select Size',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: _sizes.map((size) {
                            bool isSelected = size == _selectedSize;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedSize = size),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.only(right: 16),
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: isSelected ? const Color(0xFF387B40) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected ? const Color(0xFF387B40) : Colors.grey.shade300,
                                    width: 1.5,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    size,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected ? Colors.white : Colors.black54,
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
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.product['description'] ?? 'This gorgeous floral midi dress is perfect for summer outings. Designed with breathable woven fabric, it features soft ruffles and a delicate tie-waist to accentuate your silhouette elegantly.',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            height: 1.6,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildInfoRow(Icons.local_shipping_outlined, "Delivery in 20 working days"),
                        const SizedBox(height: 12),
                        _buildInfoRow(Icons.assignment_return_outlined, "Return within 7 days"),
                        const SizedBox(height: 30),
                        ReviewSection(
                          productId: widget.product['id'] ?? widget.product['name']!,
                          productName: widget.product['name']!,
                          productImage: widget.product['imagePath']!,
                          showAddReview: false,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16, top: 12),
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
                        backgroundColor: const Color(0xFF387B40),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(CupertinoIcons.bag_fill, color: Colors.white, size: 22),
                          SizedBox(width: 12),
                          Text(
                            'Add to Cart',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF387B40), size: 20),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
