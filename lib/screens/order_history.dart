import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_header.dart';
import 'package:intl/intl.dart';
import '../providers/order_provider.dart';
import '../models/order_model.dart';
import '../models/order_status.dart';
import '../widgets/review_section.dart';
import 'my_reviews.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF387B40);
    const Color lightGreen = Color(0xFF8CC18D);

    return Scaffold(
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
            children: [
              CustomHeader(
                title: 'Order History',
                action: IconButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MyReviewsPage())),
                  icon: const Icon(Icons.rate_review_outlined, color: primaryColor),
                ),
              ),
              Expanded(
                child: Consumer<OrderProvider>(
                  builder: (context, orderProvider, child) {
                    return StreamBuilder<List<OrderModel>>(
                      stream: orderProvider.orders,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator(color: primaryColor));
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.shopping_bag_outlined, size: 80, color: lightGreen.withValues(alpha: 0.5)),
                                const SizedBox(height: 16),
                                const Text(
                                  'No orders yet',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Georgia',
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        final orders = snapshot.data!;
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            final order = orders[index];
                            final date = DateFormat('dd MMM yyyy').format(order.createdAt);
                            final total = order.totalAmount;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: lightGreen, width: 1.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Order #${order.orderId.substring(0, 8).toUpperCase()}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 16,
                                            fontFamily: 'Georgia',
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: _getStatusColor(order.status).withValues(alpha: 0.2),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            order.status.toUpperCase(),
                                            style: TextStyle(
                                              color: _getStatusColor(order.status),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(height: 24),
                                    
                                    // Items List
                                    ...order.items.map((item) => Padding(
                                      padding: const EdgeInsets.only(bottom: 12),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(8),
                                                child: Image.asset(
                                                  item.productImage,
                                                  width: 40,
                                                  height: 40,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (c, e, s) => const Icon(Icons.shopping_bag_outlined),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      item.productName,
                                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                                    ),
                                                    Text(
                                                      '${item.quantity}x Rs.${item.price.toStringAsFixed(0)}',
                                                      style: const TextStyle(color: Colors.black54, fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )),
                                    
                                    const Divider(height: 24),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Date: $date',
                                          style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 100,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              'Rs.${total.toStringAsFixed(0)}',
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w900,
                                                fontFamily: 'Georgia',
                                                color: primaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Left Side: Cancel or Return
                                        if (order.status == OrderStatus.processing)
                                          SizedBox(
                                            width: 150,
                                            child: ElevatedButton(
                                              onPressed: () => _handleCancel(context, order),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red.shade50,
                                                foregroundColor: Colors.red,
                                                elevation: 0,
                                                side: const BorderSide(color: Colors.red),
                                                padding: const EdgeInsets.symmetric(vertical: 12),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                              ),
                                              child: const Text('Cancel Order', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                            ),
                                          )
                                        else if (order.status == OrderStatus.delivered && _isWithinReturnPeriod(order))
                                          SizedBox(
                                            width: 150,
                                            child: ElevatedButton(
                                              onPressed: () => _handleReturn(context, order),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.orange.shade50,
                                                foregroundColor: Colors.orange,
                                                elevation: 0,
                                                side: const BorderSide(color: Colors.orange),
                                                padding: const EdgeInsets.symmetric(vertical: 12),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                              ),
                                              child: const Text('Return Order', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                            ),
                                          )
                                        else
                                          const SizedBox(width: 150), // Placeholder to keep Add Review on right
                                        
                                        // Right Side: Add Review
                                        SizedBox(
                                          width: 150,
                                          child: ElevatedButton.icon(
                                            onPressed: () {
                                              if (order.items.isNotEmpty) {
                                                final item = order.items.first;
                                                _showReviewSheet(context, item.productId, item.productName, item.productImage);
                                              }
                                            },
                                            icon: const Icon(Icons.rate_review_outlined, size: 16),
                                            label: const Text('Add Review'),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: primaryColor.withValues(alpha: 0.1),
                                              foregroundColor: primaryColor,
                                              elevation: 0,
                                              padding: const EdgeInsets.symmetric(vertical: 12),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                              side: const BorderSide(color: primaryColor, width: 0.5),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
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

  bool _isWithinReturnPeriod(OrderModel order) {
    return DateTime.now().difference(order.deliveryDate).inDays <= 7;
  }

  void _handleCancel(BuildContext context, OrderModel order) async {
    final confirmed = await _showConfirmDialog(context, 'Cancel Order', 'Are you sure you want to cancel this order?');
    if (confirmed == true && context.mounted) {
      try {
        await context.read<OrderProvider>().cancelOrder(order.orderId);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order cancelled successfully')));
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
        }
      }
    }
  }

  void _handleReturn(BuildContext context, OrderModel order) async {
    final confirmed = await _showConfirmDialog(context, 'Return Order', 'Are you sure you want to return this order?');
    if (confirmed == true && context.mounted) {
      try {
        await context.read<OrderProvider>().returnOrder(order.orderId);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Return request submitted')));
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
        }
      }
    }
  }

  Future<bool?> _showConfirmDialog(BuildContext context, String title, String content) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(content),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Yes')),
        ],
      ),
    );
  }

  void _showReviewSheet(BuildContext context, String productId, String productName, String productImage) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ReviewSection(
        productId: productId,
        productName: productName,
        productImage: productImage,
        themeColor: const Color(0xFF387B40),
        showAddReview: true,
        onlyAddMode: true,
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case OrderStatus.delivered:
        return const Color(0xFF387B40);
      case OrderStatus.processing:
        return Colors.orange;
      case OrderStatus.shipped:
        return Colors.blue;
      case OrderStatus.cancelled:
        return Colors.red;
      case OrderStatus.returned:
        return Colors.deepPurple;
      default:
        return Colors.grey;
    }
  }
}
