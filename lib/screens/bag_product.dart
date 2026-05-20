import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'bag_details.dart';
import '../widgets/custom_header.dart';
import '../providers/product_provider.dart';
import '../models/product_model.dart';
import '../providers/auth_provider.dart';
import '../providers/wishlist_provider.dart';

class BagProductPage extends StatefulWidget {
  const BagProductPage({super.key});

  @override
  State<BagProductPage> createState() => _BagProductPageState();
}

class _BagProductPageState extends State<BagProductPage> {
  String _selectedFilter = 'All';
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF387B40);

    return Scaffold(
      backgroundColor: Colors.white,
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const CustomHeader(title: "Luggage & bags"),
              const SizedBox(height: 24),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: primaryColor, width: 1.5),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: const Icon(
                        CupertinoIcons.search,
                        color: Colors.grey,
                        size: 20,
                      ),
                      hintText: 'Search bags',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Filter Pills
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildFilterPill(
                      'All',
                      _selectedFilter == 'All',
                      primaryColor,
                    ),
                    _buildFilterPill(
                      'Recent',
                      _selectedFilter == 'Recent',
                      primaryColor,
                    ),
                    _buildFilterPill(
                      'Popular',
                      _selectedFilter == 'Popular',
                      primaryColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Product Grid
              Expanded(
                child: Consumer<ProductProvider>(
                  builder: (context, productProvider, child) {
                    return StreamBuilder<List<ProductModel>>(
                      stream: productProvider.getProducts('bag'),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          );
                        }

                        var products = snapshot.data ?? [];

                        // Apply search filter
                        if (_searchController.text.isNotEmpty) {
                          products = products
                              .where(
                                (p) => p.name.toLowerCase().contains(
                                  _searchController.text.toLowerCase(),
                                ),
                              )
                              .toList();
                        }

                        // Apply category filter
                        if (_selectedFilter == 'Recent') {
                          products.sort((a, b) => (b.id).compareTo(a.id));
                        } else if (_selectedFilter == 'Popular') {
                          products.sort((a, b) => (b.price).compareTo(a.price));
                        }

                        if (products.isEmpty) {
                          return Center(
                            child: Text(
                              _searchController.text.isNotEmpty
                                  ? 'No bags found matching your search'
                                  : 'No bags found',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: GridView.builder(
                            itemCount: products.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 0.72,
                                ),
                            padding: const EdgeInsets.only(bottom: 120),
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return _buildBagCard(products[index]);
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
      ),
    );
  }

  Widget _buildFilterPill(String label, bool isSelected, Color primaryColor) {
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF7FB285)
              : const Color(0xFF7FB285).withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            fontFamily: 'Georgia',
          ),
        ),
      ),
    );
  }

  Widget _buildBagCard(ProductModel product) {
    final String imagePath = product.images.isNotEmpty ? product.images[0] : '';
    final bool isNetworkImage =
        imagePath.isNotEmpty && imagePath.startsWith('http');

    return GestureDetector(
      onTap: () {
        context.read<ProductProvider>().viewProduct(product.id);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BagDetailsPage(
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
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
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
                      child: imagePath.isEmpty
                          ? const Center(
                              child: Icon(
                                Icons.image,
                                size: 40,
                                color: Colors.grey,
                              ),
                            )
                          : isNetworkImage
                          ? Image.network(
                              imagePath,
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) => const Icon(
                                Icons.image,
                                size: 40,
                                color: Colors.grey,
                              ),
                            )
                          : Image.asset(
                              imagePath,
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) => const Icon(
                                Icons.image,
                                size: 40,
                                color: Colors.grey,
                              ),
                            ),
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
                              isWishlisted
                                  ? CupertinoIcons.heart_fill
                                  : CupertinoIcons.heart,
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
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Georgia',
                        fontSize: 15,
                        height: 1.1,
                      ),
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
