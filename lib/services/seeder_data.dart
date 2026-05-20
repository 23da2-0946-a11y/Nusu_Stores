import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class SeederData {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> seedProducts() async {
    final productsCollection = _db.collection('products');

    debugPrint('Starting Firestore seeding (force update)...');

    final List<Map<String, dynamic>> products = [
      // --- MEN CATEGORY ---
      // Shirts
      {'name': 'Premium Cotton Shirt', 'price': 1500.0, 'category': 'men', 'subCategory': 'shirt', 'images': ['lib/assets/images/men_category/shirts/shirt.png'], 'description': 'A high-quality cotton shirt designed for comfort and style.', 'sizes': ['S', 'M', 'L', 'XL'], 'colors': ['White', 'Blue'], 'stock': 50, 'createdAt': FieldValue.serverTimestamp(), 'views': 120, 'isTrending': true},
      {'name': 'Casual Denim Shirt', 'price': 1800.0, 'category': 'men', 'subCategory': 'shirt', 'images': ['lib/assets/images/men_category/shirts/14.jpg'], 'description': 'Classic denim shirt for a rugged look.', 'sizes': ['M', 'L', 'XL'], 'colors': ['Blue'], 'stock': 30, 'createdAt': FieldValue.serverTimestamp(), 'views': 85, 'isTrending': false},
      {'name': 'Checkered Casual Shirt', 'price': 1400.0, 'category': 'men', 'subCategory': 'shirt', 'images': ['lib/assets/images/men_category/shirts/15.jpg'], 'description': 'Comfortable checkered shirt.', 'sizes': ['M', 'L'], 'colors': ['Red/Black'], 'stock': 20, 'createdAt': FieldValue.serverTimestamp(), 'views': 40, 'isTrending': false},
      {'name': 'Formal Office Shirt', 'price': 1600.0, 'category': 'men', 'subCategory': 'shirt', 'images': ['lib/assets/images/men_category/shirts/16.jpg'], 'description': 'Sharp formal shirt for office wear.', 'sizes': ['S', 'M', 'L', 'XL'], 'colors': ['White', 'Light Blue'], 'stock': 40, 'createdAt': FieldValue.serverTimestamp(), 'views': 110, 'isTrending': true},
      {'name': 'Printed Summer Shirt', 'price': 1300.0, 'category': 'men', 'subCategory': 'shirt', 'images': ['lib/assets/images/men_category/shirts/17.webp'], 'description': 'Light breathable printed shirt.', 'sizes': ['M', 'L'], 'colors': ['Multicolor'], 'stock': 25, 'createdAt': FieldValue.serverTimestamp(), 'views': 60, 'isTrending': false},
      {'name': 'Linen Blend Shirt', 'price': 1900.0, 'category': 'men', 'subCategory': 'shirt', 'images': ['lib/assets/images/men_category/shirts/18.webp'], 'description': 'Premium linen blend for maximum comfort.', 'sizes': ['L', 'XL'], 'colors': ['Beige'], 'stock': 15, 'createdAt': FieldValue.serverTimestamp(), 'views': 90, 'isTrending': false},
      {'name': 'Oxford Button Down', 'price': 1750.0, 'category': 'men', 'subCategory': 'shirt', 'images': ['lib/assets/images/men_category/shirts/19.webp'], 'description': 'Classic oxford button-down shirt.', 'sizes': ['S', 'M', 'L', 'XL'], 'colors': ['Blue', 'White'], 'stock': 45, 'createdAt': FieldValue.serverTimestamp(), 'views': 130, 'isTrending': true},
      {'name': 'Saved Men Shirt', 'price': 1500.0, 'category': 'men', 'subCategory': 'shirt', 'images': ['lib/assets/images/men_category/shirts/saved_men.png'], 'description': 'Stylish casual shirt.', 'sizes': ['M', 'L'], 'colors': ['Navy'], 'stock': 30, 'createdAt': FieldValue.serverTimestamp(), 'views': 50, 'isTrending': false},
      
      // Pants
      {'name': 'Slim Fit Chinos', 'price': 2200.0, 'category': 'men', 'subCategory': 'pants', 'images': ['lib/assets/images/men_category/pants/13.png'], 'description': 'Modern slim-fit chinos for any occasion.', 'sizes': ['30', '32', '34', '36'], 'colors': ['Beige', 'Black'], 'stock': 40, 'createdAt': FieldValue.serverTimestamp(), 'views': 210, 'isTrending': true},
      {'name': 'Classic Jeans', 'price': 2500.0, 'category': 'men', 'subCategory': 'pants', 'images': ['lib/assets/images/men_category/pants/8.jpg'], 'description': 'Durable and classic blue jeans.', 'sizes': ['32', '34', '36'], 'colors': ['Blue', 'Dark Blue'], 'stock': 60, 'createdAt': FieldValue.serverTimestamp(), 'views': 300, 'isTrending': true},
      {'name': 'Cargo Pants', 'price': 2100.0, 'category': 'men', 'subCategory': 'pants', 'images': ['lib/assets/images/men_category/pants/9.jpg'], 'description': 'Utilitarian cargo pants with multiple pockets.', 'sizes': ['30', '32', '34'], 'colors': ['Olive', 'Khaki'], 'stock': 35, 'createdAt': FieldValue.serverTimestamp(), 'views': 140, 'isTrending': false},
      {'name': 'Formal Trousers', 'price': 2400.0, 'category': 'men', 'subCategory': 'pants', 'images': ['lib/assets/images/men_category/pants/10.webp'], 'description': 'Elegant formal trousers.', 'sizes': ['32', '34', '36', '38'], 'colors': ['Black', 'Navy', 'Grey'], 'stock': 50, 'createdAt': FieldValue.serverTimestamp(), 'views': 180, 'isTrending': true},
      {'name': 'Jogger Pants', 'price': 1600.0, 'category': 'men', 'subCategory': 'pants', 'images': ['lib/assets/images/men_category/pants/11.webp'], 'description': 'Comfortable jogger pants for athletic or casual wear.', 'sizes': ['M', 'L', 'XL'], 'colors': ['Grey', 'Black'], 'stock': 45, 'createdAt': FieldValue.serverTimestamp(), 'views': 220, 'isTrending': true},
      {'name': 'Distressed Jeans', 'price': 2700.0, 'category': 'men', 'subCategory': 'pants', 'images': ['lib/assets/images/men_category/pants/12.webp'], 'description': 'Trendy distressed denim jeans.', 'sizes': ['30', '32', '34'], 'colors': ['Light Blue'], 'stock': 25, 'createdAt': FieldValue.serverTimestamp(), 'views': 160, 'isTrending': false},

      // T-Shirts
      {'name': 'Urban Graphic Tee', 'price': 900.0, 'category': 'men', 'subCategory': 't-shirt', 'images': ['lib/assets/images/men_category/t-shirts/45.jpg'], 'description': 'Cool graphic t-shirt with urban vibes.', 'sizes': ['S', 'M', 'L', 'XL'], 'colors': ['Grey', 'Black'], 'stock': 60, 'createdAt': FieldValue.serverTimestamp(), 'views': 150, 'isTrending': true},
      {'name': 'Basic Solid Tee', 'price': 700.0, 'category': 'men', 'subCategory': 't-shirt', 'images': ['lib/assets/images/men_category/t-shirts/52.jpg'], 'description': 'Essential solid color t-shirt.', 'sizes': ['S', 'M', 'L', 'XL', 'XXL'], 'colors': ['White', 'Black', 'Navy'], 'stock': 100, 'createdAt': FieldValue.serverTimestamp(), 'views': 250, 'isTrending': true},
      {'name': 'V-Neck T-Shirt', 'price': 850.0, 'category': 'men', 'subCategory': 't-shirt', 'images': ['lib/assets/images/men_category/t-shirts/58.webp'], 'description': 'Stylish v-neck tee.', 'sizes': ['M', 'L', 'XL'], 'colors': ['Grey', 'White'], 'stock': 40, 'createdAt': FieldValue.serverTimestamp(), 'views': 110, 'isTrending': false},
      {'name': 'Striped Casual Tee', 'price': 950.0, 'category': 'men', 'subCategory': 't-shirt', 'images': ['lib/assets/images/men_category/t-shirts/74.webp'], 'description': 'Classic striped t-shirt.', 'sizes': ['S', 'M', 'L'], 'colors': ['Blue/White'], 'stock': 35, 'createdAt': FieldValue.serverTimestamp(), 'views': 90, 'isTrending': false},

      // Caps
      {'name': 'Classic Baseball Cap', 'price': 600.0, 'category': 'men', 'subCategory': 'caps', 'images': ['lib/assets/images/men_category/caps/cap.png'], 'description': 'Stylish cap to complete your casual look.', 'sizes': ['One Size'], 'colors': ['Black', 'Navy'], 'stock': 100, 'createdAt': FieldValue.serverTimestamp(), 'views': 45, 'isTrending': false},
      {'name': 'Sports Cap', 'price': 650.0, 'category': 'men', 'subCategory': 'caps', 'images': ['lib/assets/images/men_category/caps/2.webp'], 'description': 'Lightweight cap for athletic activities.', 'sizes': ['One Size'], 'colors': ['White', 'Red'], 'stock': 80, 'createdAt': FieldValue.serverTimestamp(), 'views': 120, 'isTrending': true},
      {'name': 'Trucker Hat', 'price': 550.0, 'category': 'men', 'subCategory': 'caps', 'images': ['lib/assets/images/men_category/caps/3.jpg'], 'description': 'Classic trucker hat with mesh back.', 'sizes': ['One Size'], 'colors': ['Black/White'], 'stock': 60, 'createdAt': FieldValue.serverTimestamp(), 'views': 70, 'isTrending': false},
      {'name': 'Snapback Cap', 'price': 700.0, 'category': 'men', 'subCategory': 'caps', 'images': ['lib/assets/images/men_category/caps/4.jpg'], 'description': 'Premium snapback with flat brim.', 'sizes': ['One Size'], 'colors': ['Navy'], 'stock': 40, 'createdAt': FieldValue.serverTimestamp(), 'views': 90, 'isTrending': true},
      {'name': 'Logo Cap', 'price': 750.0, 'category': 'men', 'subCategory': 'caps', 'images': ['lib/assets/images/men_category/caps/5.png'], 'description': 'Branded logo cap.', 'sizes': ['One Size'], 'colors': ['Black'], 'stock': 50, 'createdAt': FieldValue.serverTimestamp(), 'views': 85, 'isTrending': false},
      {'name': 'Vintage Cap', 'price': 600.0, 'category': 'men', 'subCategory': 'caps', 'images': ['lib/assets/images/men_category/caps/6.webp'], 'description': 'Vintage washed cap.', 'sizes': ['One Size'], 'colors': ['Olive'], 'stock': 35, 'createdAt': FieldValue.serverTimestamp(), 'views': 60, 'isTrending': false},
      {'name': 'Performance Cap', 'price': 800.0, 'category': 'men', 'subCategory': 'caps', 'images': ['lib/assets/images/men_category/caps/7.webp'], 'description': 'High-performance running cap.', 'sizes': ['One Size'], 'colors': ['Grey'], 'stock': 45, 'createdAt': FieldValue.serverTimestamp(), 'views': 110, 'isTrending': true},

      // --- WOMEN CATEGORY ---
      // Tops
      {'name': 'Floral Print Top', 'price': 1200.0, 'category': 'women', 'subCategory': 'tops', 'images': ['lib/assets/images/women_category/top/34.jpg'], 'description': 'Beautiful floral top for a feminine touch.', 'sizes': ['S', 'M', 'L'], 'colors': ['Multicolor'], 'stock': 35, 'createdAt': FieldValue.serverTimestamp(), 'views': 140, 'isTrending': false},
      {'name': 'Casual Cotton Top', 'price': 950.0, 'category': 'women', 'subCategory': 'tops', 'images': ['lib/assets/images/women_category/top/37.png'], 'description': 'Comfortable cotton top for casual wear.', 'sizes': ['S', 'M', 'L', 'XL'], 'colors': ['White', 'Grey'], 'stock': 40, 'createdAt': FieldValue.serverTimestamp(), 'views': 75, 'isTrending': false},
      {'name': 'Elegant Blouse', 'price': 1600.0, 'category': 'women', 'subCategory': 'tops', 'images': ['lib/assets/images/women_category/top/35.jpg'], 'description': 'Elegant blouse for work or evening wear.', 'sizes': ['XS', 'S', 'M', 'L'], 'colors': ['White', 'Pink'], 'stock': 25, 'createdAt': FieldValue.serverTimestamp(), 'views': 190, 'isTrending': true},
      {'name': 'Summer Tank Top', 'price': 750.0, 'category': 'women', 'subCategory': 'tops', 'images': ['lib/assets/images/women_category/top/36.jpg'], 'description': 'Essential summer tank top.', 'sizes': ['S', 'M', 'L'], 'colors': ['Black', 'White', 'Yellow'], 'stock': 60, 'createdAt': FieldValue.serverTimestamp(), 'views': 210, 'isTrending': true},
      {'name': 'Chiffon Tunic', 'price': 1800.0, 'category': 'women', 'subCategory': 'tops', 'images': ['lib/assets/images/women_category/top/38.png'], 'description': 'Lightweight chiffon tunic.', 'sizes': ['M', 'L', 'XL'], 'colors': ['Blue'], 'stock': 20, 'createdAt': FieldValue.serverTimestamp(), 'views': 120, 'isTrending': false},
      {'name': 'Lace Detail Top', 'price': 1450.0, 'category': 'women', 'subCategory': 'tops', 'images': ['lib/assets/images/women_category/top/39.png'], 'description': 'Delicate top with lace detailing.', 'sizes': ['S', 'M', 'L'], 'colors': ['Cream'], 'stock': 30, 'createdAt': FieldValue.serverTimestamp(), 'views': 150, 'isTrending': true},
      {'name': 'Knit Sweater Top', 'price': 2100.0, 'category': 'women', 'subCategory': 'tops', 'images': ['lib/assets/images/women_category/top/40.png'], 'description': 'Cozy knit sweater top for cooler days.', 'sizes': ['S', 'M', 'L'], 'colors': ['Grey', 'Beige'], 'stock': 40, 'createdAt': FieldValue.serverTimestamp(), 'views': 250, 'isTrending': true},
      
      // Pants & Skirts
      {'name': 'Midi Silk Skirt', 'price': 1900.0, 'category': 'women', 'subCategory': 'skirts', 'images': ['lib/assets/images/women_category/pants/27.jpg'], 'description': 'Elegant midi silk skirt for a polished look.', 'sizes': ['S', 'M', 'L'], 'colors': ['Champagne', 'Black'], 'stock': 15, 'createdAt': FieldValue.serverTimestamp(), 'views': 110, 'isTrending': true},
      {'name': 'High-Waist Jeans', 'price': 2400.0, 'category': 'women', 'subCategory': 'pants', 'images': ['lib/assets/images/women_category/pants/24.jpg'], 'description': 'Flattering high-waisted denim jeans.', 'sizes': ['26', '28', '30', '32'], 'colors': ['Blue', 'Black'], 'stock': 50, 'createdAt': FieldValue.serverTimestamp(), 'views': 320, 'isTrending': true},
      {'name': 'Wide Leg Trousers', 'price': 2600.0, 'category': 'women', 'subCategory': 'pants', 'images': ['lib/assets/images/women_category/pants/25.jpg'], 'description': 'Comfortable and chic wide-leg trousers.', 'sizes': ['S', 'M', 'L'], 'colors': ['Beige', 'Navy'], 'stock': 35, 'createdAt': FieldValue.serverTimestamp(), 'views': 180, 'isTrending': true},
      {'name': 'Pleated Skirt', 'price': 1750.0, 'category': 'women', 'subCategory': 'skirts', 'images': ['lib/assets/images/women_category/pants/26.jpg'], 'description': 'Classic pleated skirt for a timeless look.', 'sizes': ['S', 'M', 'L'], 'colors': ['Black', 'Grey'], 'stock': 25, 'createdAt': FieldValue.serverTimestamp(), 'views': 140, 'isTrending': false},

      // Shoes
      {'name': 'Classic Stiletto Heels', 'price': 3800.0, 'category': 'women', 'subCategory': 'shoes', 'images': ['lib/assets/images/women_category/shoes/31.jpg'], 'description': 'Elegant heels for your special night out.', 'sizes': ['36', '37', '38', '39'], 'colors': ['Red', 'Black'], 'stock': 15, 'createdAt': FieldValue.serverTimestamp(), 'views': 500, 'isTrending': true},
      {'name': 'Casual Sneakers', 'price': 2500.0, 'category': 'women', 'subCategory': 'shoes', 'images': ['lib/assets/images/women_category/shoes/28.jpg'], 'description': 'Everyday comfort sneakers.', 'sizes': ['37', '38', '39', '40'], 'colors': ['White', 'Pink'], 'stock': 60, 'createdAt': FieldValue.serverTimestamp(), 'views': 350, 'isTrending': true},
      {'name': 'Leather Loafers', 'price': 3200.0, 'category': 'women', 'subCategory': 'shoes', 'images': ['lib/assets/images/women_category/shoes/29.jpg'], 'description': 'Stylish leather loafers for work or play.', 'sizes': ['36', '37', '38', '39'], 'colors': ['Brown', 'Black'], 'stock': 30, 'createdAt': FieldValue.serverTimestamp(), 'views': 210, 'isTrending': false},
      {'name': 'Strappy Sandals', 'price': 1900.0, 'category': 'women', 'subCategory': 'shoes', 'images': ['lib/assets/images/women_category/shoes/30.jpg'], 'description': 'Perfect sandals for warm weather.', 'sizes': ['36', '37', '38', '39'], 'colors': ['Tan', 'Black'], 'stock': 45, 'createdAt': FieldValue.serverTimestamp(), 'views': 180, 'isTrending': true},
      {'name': 'Ankle Boots', 'price': 4500.0, 'category': 'women', 'subCategory': 'shoes', 'images': ['lib/assets/images/women_category/shoes/32.png'], 'description': 'Chic ankle boots for versatile styling.', 'sizes': ['37', '38', '39'], 'colors': ['Black', 'Brown'], 'stock': 20, 'createdAt': FieldValue.serverTimestamp(), 'views': 280, 'isTrending': true},
      {'name': 'Ballet Flats', 'price': 1600.0, 'category': 'women', 'subCategory': 'shoes', 'images': ['lib/assets/images/women_category/shoes/33.png'], 'description': 'Comfortable everyday ballet flats.', 'sizes': ['36', '37', '38', '39', '40'], 'colors': ['Nude', 'Black'], 'stock': 55, 'createdAt': FieldValue.serverTimestamp(), 'views': 150, 'isTrending': false},

      // --- BAG CATEGORY ---
      {'name': 'Designer Leather Bag', 'price': 5500.0, 'category': 'bag', 'subCategory': 'all', 'images': ['lib/assets/images/bag_category/bag.png'], 'description': 'Luxury leather bag with gold-tone hardware.', 'sizes': ['One Size'], 'colors': ['Brown', 'Black'], 'stock': 12, 'createdAt': FieldValue.serverTimestamp(), 'views': 250, 'isTrending': true},
      {'name': 'Chic Girl Bag', 'price': 2800.0, 'category': 'bag', 'subCategory': 'all', 'images': ['lib/assets/images/bag_category/bages_girl.png'], 'description': 'Trendy and chic bag for everyday use.', 'sizes': ['One Size'], 'colors': ['Pink', 'Beige'], 'stock': 30, 'createdAt': FieldValue.serverTimestamp(), 'views': 310, 'isTrending': true},
      {'name': 'Classic Tote Bag', 'price': 3500.0, 'category': 'bag', 'subCategory': 'all', 'images': ['lib/assets/images/bag_category/bages.png'], 'description': 'Spacious classic tote bag.', 'sizes': ['One Size'], 'colors': ['Tan', 'Black'], 'stock': 25, 'createdAt': FieldValue.serverTimestamp(), 'views': 190, 'isTrending': false},
      {'name': 'Mini Crossbody', 'price': 2200.0, 'category': 'bag', 'subCategory': 'all', 'images': ['lib/assets/images/bag_category/d.png'], 'description': 'Compact mini crossbody bag.', 'sizes': ['One Size'], 'colors': ['Red', 'Black'], 'stock': 40, 'createdAt': FieldValue.serverTimestamp(), 'views': 270, 'isTrending': true},
    ];

    try {
      final WriteBatch batch = _db.batch();
      for (var product in products) {
        final docId = product['name'].toString().replaceAll(' ', '_').toLowerCase();
        final newDoc = productsCollection.doc(docId);
        batch.set(newDoc, product, SetOptions(merge: true));
      }

      await batch.commit();
      debugPrint('Successfully seeded ${products.length} products to Firestore!');
    } catch (e) {
      debugPrint('Failed to seed products: $e');
    }
  }
}
