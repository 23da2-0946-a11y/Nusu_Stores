class OrderStatus {
  static const String processing = 'Processing';
  static const String shipped = 'Shipped';
  static const String delivered = 'Delivered';
  static const String cancelled = 'Cancelled';
  static const String returned = 'Returned';

  static const List<String> all = [
    processing,
    shipped,
    delivered,
    cancelled,
    returned,
  ];
}
