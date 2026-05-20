import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'payment_success.dart';
import '../theme/app_colors.dart';
import '../providers/order_provider.dart';
import '../providers/cart_provider.dart';
import '../models/cart_item_model.dart';

class PaymentProcessingScreen extends StatefulWidget {
  final Map<String, dynamic> orderDetails;

  const PaymentProcessingScreen({super.key, required this.orderDetails});

  @override
  State<PaymentProcessingScreen> createState() => _PaymentProcessingScreenState();
}

class _PaymentProcessingScreenState extends State<PaymentProcessingScreen> {
  bool _isFailed = false;

  @override
  void initState() {
    super.initState();
    _startPaymentSimulation();
  }

  void _startPaymentSimulation() async {
    // Simulate payment gateway delay
    await Future.delayed(const Duration(seconds: 3));
    
    if (mounted) {
      try {
        final orderProvider = context.read<OrderProvider>();
        final cartProvider = context.read<CartProvider>();
        
        final List<CartItemModel> items = widget.orderDetails['items'] as List<CartItemModel>;
        final double total = widget.orderDetails['total'];
        
        // Create order in Firestore
        await orderProvider.placeOrder(items, total);
        
        // Clear cart
        await cartProvider.clearCart();
        
        _handleSuccess();
      } catch (e) {
        if (mounted) {
          setState(() => _isFailed = true);
        }
      }
    }
  }

  void _handleSuccess() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentSuccessScreen(
          orderDetails: widget.orderDetails,
          transactionId: 'TXN${DateTime.now().millisecondsSinceEpoch}',
        ),
      ),
    );
  }

  void _retryPayment() {
    setState(() {
      _isFailed = false;
    });
    _startPaymentSimulation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_isFailed) ...[
                // Loading State
                Container(
                  width: 120,
                  height: 120,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const CircularProgressIndicator(
                    strokeWidth: 6,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
                const SizedBox(height: 40),
                Text(
                  'Processing Payment...',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 12),
                Text(
                  'Please do not close the app or press back button',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ).animate().fadeIn(delay: 400.ms),
              ] else ...[
                // Failure State
                const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 100),
                const SizedBox(height: 32),
                Text(
                  'Payment Failed',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Something went wrong while processing your payment. Please try again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _retryPayment,
                  child: const Text('Retry Payment'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Return to Checkout', style: TextStyle(color: AppColors.textSecondary)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
