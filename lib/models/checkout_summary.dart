class CheckoutSummary {
  final double subtotal;
  final double shipping;
  final double total;
  final int itemCount;

  CheckoutSummary({
    required this.subtotal,
    required this.shipping,
    required this.total,
    required this.itemCount,
  });
}
