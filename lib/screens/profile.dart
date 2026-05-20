import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../widgets/auth_wrapper.dart';
import '../providers/auth_provider.dart';

import 'order_history.dart';
import 'address_management.dart';
import 'payment_methods.dart';
import 'my_reviews.dart';
import 'settings.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF387B40);
    const Color lightGreen = Color(0xFF8CC18D);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          final user = auth.userModel;
          final firebaseUser = auth.currentUser;
          final String userName = user?.name ?? firebaseUser?.displayName ?? 'User';
          final String userEmail = user?.email ?? firebaseUser?.email ?? 'No Email';
          final String? profileImage = user?.profileImage;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 60),
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'My Profile',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Georgia',
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Avatar Section
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: primaryColor.withValues(alpha: 0.2), width: 1),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: lightGreen, width: 3),
                          ),
                          child: CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.grey.shade100,
                            backgroundImage: profileImage != null && profileImage.isNotEmpty
                                ? NetworkImage(profileImage)
                                : null,
                            child: (profileImage == null || profileImage.isEmpty)
                                ? Icon(Icons.person, size: 80, color: primaryColor)
                                : null,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: GestureDetector(
                          onTap: () => _pickAndUploadImage(context, auth),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Name & Email
                Text(
                  userName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Georgia',
                    color: lightGreen,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userEmail,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Georgia',
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 16),

                // Badge & Review Button
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Gold Member',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Georgia',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MyReviewsPage())),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Reviews',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Georgia',
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Menu Items
                _buildMenuItem(
                  icon: Icons.assignment_rounded,
                  iconColor: primaryColor,
                  title: 'My Orders',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderHistoryPage())),
                ),
                _buildMenuItem(
                  icon: Icons.location_on_rounded,
                  iconColor: primaryColor,
                  title: 'Saved Addresses',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddressManagementPage())),
                ),
                _buildMenuItem(
                  icon: Icons.credit_card_rounded,
                  iconColor: primaryColor,
                  title: 'Payment Methods',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentMethodsPage())),
                ),
                _buildMenuItem(
                  icon: Icons.settings_rounded,
                  iconColor: primaryColor,
                  title: 'Settings',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage())),
                ),
                _buildMenuItem(
                  icon: Icons.logout_rounded,
                  iconColor: primaryColor,
                  title: 'Sign Out',
                  isLogout: true,
                  onTap: () async {
                    await auth.signOut();
                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const AuthWrapper()),
                        (route) => false,
                      );
                    }
                  },
                ),
                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Column(
      children: [
        const Divider(height: 1, thickness: 1),
        ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          leading: Icon(icon, color: isLogout ? Colors.black : iconColor, size: 28),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isLogout ? const Color(0xFF387B40) : Colors.black87,
            ),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.black, size: 28),
        ),
      ],
    );
  }



  Future<void> _pickAndUploadImage(BuildContext context, AuthProvider auth) async {
    final ImagePicker picker = ImagePicker();
    
    // Show options
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );

    if (source != null) {
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 512,
        maxHeight: 512,
      );

      if (image != null && context.mounted) {
        try {
          final String? uid = auth.uid;
          if (uid != null) {
            await auth.updateProfileImage(uid, image.path);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile image updated successfully')),
              );
            }
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to upload image: $e')),
            );
          }
        }
      }
    }
  }


}
