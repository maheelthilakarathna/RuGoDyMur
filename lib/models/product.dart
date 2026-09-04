import 'product_size.dart';

class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final double rating;
  final int reviewCount;
  final String description;
  final List<String> details;
  final List<ProductSize> sizes;
  final String icon;
  final String tint;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.details,
    required this.sizes,
    required this.icon,
    required this.tint,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      description: json['description'] as String,
      details: (json['details'] as List).map((e) => e as String).toList(),
      sizes: (json['sizes'] as List)
          .map((e) => ProductSize.fromJson(e as Map<String, dynamic>))
          .toList(),
      icon: json['icon'] as String,
      tint: json['tint'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'price': price,
    'rating': rating,
    'reviewCount': reviewCount,
    'description': description,
    'details': details,
    'sizes': sizes.map((s) => s.toJson()).toList(),
    'icon': icon,
    'tint': tint,
  };
}
