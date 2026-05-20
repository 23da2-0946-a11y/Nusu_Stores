import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String name;
  final double price;
  final String category;
  final String subCategory;
  final List<String> images;
  final String description;
  final List<String> sizes;
  final List<String> colors;
  final int stock;
  final DateTime createdAt;
  final int views;
  final bool isTrending;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.subCategory,
    required this.images,
    required this.description,
    required this.sizes,
    required this.colors,
    required this.stock,
    required this.createdAt,
    required this.views,
    required this.isTrending,
  });

  factory ProductModel.fromMap(Map<String, dynamic> data, String id) {
    return ProductModel(
      id: id,
      name: data['name'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      category: data['category'] ?? '',
      subCategory: data['subCategory'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      description: data['description'] ?? '',
      sizes: List<String>.from(data['sizes'] ?? []),
      colors: List<String>.from(data['colors'] ?? []),
      stock: data['stock'] ?? 0,
      createdAt: data['createdAt'] != null 
          ? (data['createdAt'] is Timestamp ? (data['createdAt'] as Timestamp).toDate() : DateTime.parse(data['createdAt'])) 
          : DateTime.now(),
      views: data['views'] ?? 0,
      isTrending: data['isTrending'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'category': category,
      'subCategory': subCategory,
      'images': images,
      'description': description,
      'sizes': sizes,
      'colors': colors,
      'stock': stock,
      'createdAt': createdAt,
      'views': views,
      'isTrending': isTrending,
    };
  }
}
