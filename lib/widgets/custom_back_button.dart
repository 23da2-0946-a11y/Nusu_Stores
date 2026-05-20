import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../screens/main_screen.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final bool forceShow;

  const CustomBackButton({
    super.key,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size = 18,
    this.forceShow = false,
  });

  Future<void> _handleBack(BuildContext context) async {
    if (onPressed != null) {
      onPressed!();
      return;
    }

    final canPop = Navigator.canPop(context);
    if (canPop) {
      Navigator.pop(context);
    } else if (forceShow) {
      final shouldExit = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Exit App', style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text('Are you sure you want to exit the application?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Exit', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );

      if (shouldExit == true) {
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
            (route) => false,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);
    
    if (!canPop && !forceShow) {
      return const SizedBox.shrink();
    }

    return Hero(
      tag: 'custom_back_button_${context.hashCode}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleBack(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: backgroundColor ?? AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Theme.of(context).platform == TargetPlatform.iOS 
                ? Icons.arrow_back_ios_new 
                : Icons.arrow_back,
              size: size,
              color: iconColor ?? AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
