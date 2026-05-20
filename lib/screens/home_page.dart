import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'women_product.dart';
import 'men_product.dart';
import 'bag_product.dart';
import 'profile.dart';
import 'bag_details.dart';
import 'men_details.dart';
import 'women_details.dart';
import 'cart.dart';
import '../widgets/custom_back_button.dart';
import '../theme/app_colors.dart';
import '../providers/auth_provider.dart';
import '../providers/product_provider.dart';
import '../providers/wishlist_provider.dart';
import '../models/product_model.dart';
import '../services/seeder_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    // Seed data when entering home screen
    SeederData.seedProducts();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.backgroundGradient,
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    _buildSearchBar(),
                    const SizedBox(height: 24),
                    _buildCategories(),
                    const SizedBox(height: 32),
                    _buildHeroBanner(),
                    const SizedBox(height: 32),
                    _buildSectionTitle(_selectedCategory == 'All' ? 'Trending Now' : '$_selectedCategory Collection'),
                    const SizedBox(height: 16),
                    _buildProductGrid(),
                    const SizedBox(height: 120), // Extra space for bottom nav
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        final userName = auth.userModel?.name.split(' ').first ?? 'User';
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CustomBackButton(
                    forceShow: true,
                    backgroundColor: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getGreeting(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.primaryLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            userName,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text('✨', style: TextStyle(fontSize: 20)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  _buildHeaderAction(
                    icon: CupertinoIcons.bag,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CartPage()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildHeaderAction(
                    icon: CupertinoIcons.person,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ProfilePage()),
                    ),
                    isProfile: true,
                    profileImage: auth.userModel?.profileImage,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeaderAction({required IconData icon, required VoidCallback onTap, bool isProfile = false, String? profileImage}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: isProfile && profileImage != null && profileImage.isNotEmpty ? EdgeInsets.zero : const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isProfile && (profileImage == null || profileImage.isEmpty) ? AppColors.primary : Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: isProfile && profileImage != null && profileImage.isNotEmpty
            ? CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(profileImage),
              )
            : Icon(
                icon,
                color: isProfile ? Colors.white : AppColors.textPrimary,
                size: 22,
              ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search styles, brands...',
          prefixIcon: const Icon(CupertinoIcons.search, color: AppColors.primary, size: 20),
          suffixIcon: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(CupertinoIcons.slider_horizontal_3, color: AppColors.primary, size: 18),
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    final categories = ['All', 'Women', 'Men', 'Bags'];
    return SizedBox(
      height: 45,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final isSelected = _selectedCategory == categories[index];
          return GestureDetector(
            onTap: () {
              setState(() => _selectedCategory = categories[index]);
              if (index == 1) Navigator.push(context, MaterialPageRoute(builder: (context) => const WomanProductPage()));
              if (index == 2) Navigator.push(context, MaterialPageRoute(builder: (context) => const MenProductPage()));
              if (index == 3) Navigator.push(context, MaterialPageRoute(builder: (context) => const BagProductPage()));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.accent.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  categories[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      constraints: const BoxConstraints(minHeight: 180),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFFE8EED3), Color(0xFFD4E2AF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -10,
              bottom: -10,
              width: 200,
              child: Image.asset(
                'lib/assets/images/home_page/dress.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const SizedBox(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'NEW SEASON',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Up to 40% OFF\non New Arrivals',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      height: 1.2,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(120, 40),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Shop Now'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'See All',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductGrid() {
    final productProvider = context.read<ProductProvider>();
    return StreamBuilder<List<ProductModel>>(
      stream: productProvider.getProducts(_selectedCategory == 'Bags' ? 'bag' : _selectedCategory),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No products found'));
        }
        final products = snapshot.data!;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.68,
          ),
          itemBuilder: (context, index) {
            return _buildProductCard(products[index]);
          },
        );
      },
    );
  }

  Widget _buildProductCard(ProductModel product) {
    return GestureDetector(
      onTap: () {
        context.read<ProductProvider>().viewProduct(product.id);
        if (product.category == 'bag') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => BagDetailsPage(product: {
            'name': product.name,
            'price': 'Rs.${product.price}',
            'imagePath': product.images.isNotEmpty ? product.images[0] : '',
            'description': product.description,
            'id': product.id,
          })));
        } else if (product.category == 'men') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => MenDetailsPage(product: {
            'name': product.name,
            'price': 'Rs.${product.price}',
            'imagePath': product.images.isNotEmpty ? product.images[0] : '',
            'description': product.description,
            'id': product.id,
          })));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) => WomenDetailsPage(product: {
            'name': product.name,
            'price': 'Rs.${product.price}',
            'imagePath': product.images.isNotEmpty ? product.images[0] : '',
            'description': product.description,
            'id': product.id,
          })));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
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
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      child: product.images.isNotEmpty 
                        ? (product.images[0].startsWith('http')
                            ? Image.network(product.images[0], fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, color: Colors.grey))
                            : Image.asset(product.images[0], fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, color: Colors.grey)))
                        : const Icon(Icons.image, color: Colors.grey),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.category.toUpperCase(),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            'Rs.${product.price}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w800,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.add, color: Colors.white, size: 18),
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
