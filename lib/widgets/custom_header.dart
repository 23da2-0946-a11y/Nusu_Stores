import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../screens/cart.dart';
import '../theme/app_colors.dart';
import 'custom_back_button.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final Widget? action;
  final bool? showBackButton;
  final bool forceShow;

  const CustomHeader({
    super.key,
    required this.title,
    this.action,
    this.showBackButton,
    this.forceShow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                if (showBackButton ?? (Navigator.canPop(context) || forceShow)) ...[
                  CustomBackButton(forceShow: forceShow),
                  const SizedBox(width: 16),
                ],
                Expanded(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (action != null) ...[
            const SizedBox(width: 8),
            action!,
            const SizedBox(width: 8),
          ],
          Stack(
            children: [
              IconButton.filled(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartPage()),
                ),
                icon: const Icon(CupertinoIcons.bag_fill, size: 22),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(12),
                ),
              ).animate(onPlay: (controller) => controller.repeat(reverse: true))
               .shimmer(duration: 2.seconds, color: Colors.white24),
            ],
          ),
        ],
      ),
    );
  }
}
