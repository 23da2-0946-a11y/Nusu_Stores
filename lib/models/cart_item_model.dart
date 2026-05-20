class CartItemModel {
  final String itemId;
  final String productId;
  final int quantity;
  final String selectedSize;
  final String selectedColor;
  final double price;
  final String productName;
  final String productImage;

  CartItemModel({
    required this.itemId,
    required this.productId,
    required this.quantity,
    required this.selectedSize,
    required this.selectedColor,
    required this.price,
    required this.productName,
    required this.productImage,
  });

  factory CartItemModel.fromMap(Map<String, dynamic> data, String itemId) {
    return CartItemModel(
      itemId: itemId,
      productId: data['productId'] ?? '',
      quantity: data['quantity'] ?? 1,
      selectedSize: data['selectedSize'] ?? '',
      selectedColor: data['selectedColor'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      productName: data['productName'] ?? '',
      productImage: data['productImage'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'quantity': quantity,
      'selectedSize': selectedSize,
      'selectedColor': selectedColor,
      'price': price,
      'productName': productName,
      'productImage': productImage,
    };
  }
}
