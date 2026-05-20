import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'cart_service.dart';
import 'order_service.dart';
import '../models/checkout_summary.dart';

class CheckoutService {
  final CartService _cartService = CartService();
  final OrderService _orderService = OrderService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Fetches the current user's cart data and calculates the summary.
  Future<CheckoutSummary> getCheckoutSummary() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    // Fetch the latest cart items from Firestore
    final items = await _cartService.getCartItems(user.uid).first;
    
    double subtotal = items.fold(0, (sum, item) => sum + (item.price * item.quantity));
    double shipping = 0.0; // Free shipping as per requirements
    double total = subtotal + shipping;

    return CheckoutSummary(
      subtotal: subtotal,
      shipping: shipping,
      total: total,
      itemCount: items.length,
    );
  }

  /// Simulates a payment gateway transaction.
  Future<bool> simulatePayment() async {
    // Simulate network latency for payment processing
    await Future.delayed(const Duration(seconds: 3));
    
    // In a real scenario, this would interact with Stripe, PayPal, etc.
    // Here we always return true to simulate a successful transaction.
    return true; 
  }

  /// High-level method to execute the full checkout flow.
  Future<String> executeCheckout() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    // 1. Fetch current cart items
    final items = await _cartService.getCartItems(user.uid).first;
    if (items.isEmpty) throw Exception('Cannot checkout with an empty cart');

    // 2. Calculate final amount
    final summary = await getCheckoutSummary();

    // 3. Simulate Payment
    final paymentSuccessful = await simulatePayment();
    if (!paymentSuccessful) throw Exception('Payment simulation failed');

    // 4. Create Order (Order creation logic)
    final orderId = await _orderService.createOrder(
      user.uid,
      items,
      summary.total,
    );

    // 5. Clear Cart on Success
    await _cartService.clearCart(user.uid);

    return orderId;
  }
}
