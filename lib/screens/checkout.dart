import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'payment_processing.dart';
import '../theme/app_colors.dart';
import '../providers/cart_provider.dart';
import '../widgets/custom_back_button.dart';
import '../services/firestore_service.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String _selectedPaymentMethod = 'Card';
  bool _isProcessing = false;
  final user = FirebaseAuth.instance.currentUser;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Checkout', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: const Center(
          child: CustomBackButton(
            backgroundColor: Colors.transparent,
            iconColor: AppColors.primary,
            size: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.backgroundGradient,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  _buildProgressIndicator(),
                  const SizedBox(height: 40),

                  // Delivery Address Section
                  _buildSectionTitle('Delivery Address'),
                  const SizedBox(height: 16),
                  _buildAddressSelector(),
                  const SizedBox(height: 24),
                  _buildTextField('Manual Address Entry', _addressController, CupertinoIcons.location, maxLines: 2),
                  const SizedBox(height: 40),

                  // Payment Details Section
                  _buildSectionTitle('Payment Details'),
                  const SizedBox(height: 16),
                  _buildPaymentMethodSelector(),
                  const SizedBox(height: 24),
                  
                  // Card Details Entry
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextField(
                          'Card Number', 
                          _cardNumberController, 
                          CupertinoIcons.creditcard, 
                          isCard: true,
                          formatters: [
                            LengthLimitingTextInputFormatter(19), // 16 digits + 3 spaces
                            CardNumberFormatter(),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                'Expiry', 
                                _expiryController, 
                                CupertinoIcons.calendar, 
                                isExpiry: true,
                                formatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(4),
                                  CardExpiryFormatter(),
                                ],
                              )
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildTextField(
                                'CVV', 
                                _cvvController, 
                                CupertinoIcons.lock, 
                                isCVV: true,
                                formatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(3),
                                ],
                              )
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildTextField('Cardholder Name', _nameController, CupertinoIcons.person),
                      ],
                    ),
                  ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
                  
                  const SizedBox(height: 40),

                  // Order Total Summary
                  _buildOrderSummary(),
                  const SizedBox(height: 40),

                  // Pay Button
                  _buildPayButton(),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w900,
        fontFamily: 'Georgia',
      ),
    );
  }

  Widget _buildAddressSelector() {
    if (user == null) return const SizedBox();
    return StreamBuilder<QuerySnapshot>(
      stream: FirestoreService().getAddresses(user!.uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const SizedBox();
        return SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: snapshot.data!.docs.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final address = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _addressController.text = address['details'] ?? '';
                  });
                },
                child: Container(
                  width: 200,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _addressController.text == address['details'] ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        address['label'] ?? 'Home',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _addressController.text == address['details'] ? Colors.white : AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        address['details'] ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: _addressController.text == address['details'] ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPaymentMethodSelector() {
    if (user == null) return const SizedBox();
    return StreamBuilder<QuerySnapshot>(
      stream: FirestoreService().getPaymentMethods(user!.uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const SizedBox();
        return SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: snapshot.data!.docs.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final card = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              final maskedNumber = card['number'] ?? '**** 0000';
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _cardNumberController.text = maskedNumber;
                    _nameController.text = card['name'] ?? '';
                    _expiryController.text = card['expiry'] ?? '';
                    _selectedPaymentMethod = 'Saved Card (${card['type']})';
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Saved card details selected. Please enter CVV manually for security.')),
                  );
                },
                child: Container(
                  width: 160,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(CupertinoIcons.creditcard_fill, color: AppColors.primary, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              card['type'] ?? 'Visa',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            Text(
                              maskedNumber,
                              style: const TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildOrderSummary() {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Amount',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                'Rs. ${cart.total.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPayButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isProcessing ? null : _handlePayment,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 20),
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: _isProcessing 
          ? const SizedBox(
              height: 24, 
              width: 24, 
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
            )
          : const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline_rounded, size: 22, color: Colors.white),
                SizedBox(width: 12),
                Text(
                  'Confirm & Pay Now',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
      ),
    ).animate().fadeIn(delay: 400.ms).scale();
  }

  Widget _buildProgressIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStepIndicator(Icons.check, true),
        _buildStepConnector(true),
        _buildStepIndicator(Icons.payment, true),
        _buildStepConnector(false),
        _buildStepIndicator(Icons.local_shipping_outlined, false),
      ],
    );
  }

  Widget _buildStepIndicator(IconData icon, bool isCompleted) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: isCompleted ? AppColors.primary : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: isCompleted ? AppColors.primary : AppColors.textHint,
          width: 2,
        ),
      ),
      child: Icon(
        icon,
        color: isCompleted ? Colors.white : AppColors.textHint,
        size: 20,
      ),
    );
  }

  Widget _buildStepConnector(bool isActive) {
    return Container(
      width: 40,
      height: 2,
      color: isActive ? AppColors.primary : AppColors.textHint.withValues(alpha: 0.3),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {
    bool isCard = false, 
    bool isExpiry = false, 
    bool isCVV = false,
    int maxLines = 1,
    List<TextInputFormatter>? formatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          inputFormatters: formatters,
          keyboardType: isCard || isCVV || isExpiry ? TextInputType.number : TextInputType.text,
          validator: (value) {
            if (value == null || value.trim().isEmpty) return 'Required';
            return null;
          },
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20, color: AppColors.primary),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Future<void> _handlePayment() async {
    if (!_formKey.currentState!.validate()) return;

    final cart = context.read<CartProvider>();
    if (cart.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Your cart is empty')));
      return;
    }

    setState(() => _isProcessing = true);

    final orderDetails = {
      'total': cart.total,
      'items': cart.items,
      'paymentMethod': _selectedPaymentMethod,
      'address': _addressController.text,
    };

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isProcessing = false);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentProcessingScreen(orderDetails: orderDetails),
        ),
      );
    }
  }
}

// --- Formatters (Reused from payment_methods.dart) ---

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text.replaceAll(' ', '');
    if (newValue.selection.baseOffset == 0) return newValue;
    
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(' ');
      }
    }
    
    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

class CardExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text.replaceAll('/', '');
    if (newValue.selection.baseOffset == 0) return newValue;
    
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 2 == 0 && nonZeroIndex != text.length) {
        buffer.write('/');
      }
    }
    
    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}
