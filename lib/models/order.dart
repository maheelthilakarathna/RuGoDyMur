import 'cart_item.dart';

class Order {
  final String id;
  final DateTime placedAt;
  final List<CartItem> items;
  final double total;
  final double? deliveryLat;
  final double? deliveryLng;

  const Order({
    required this.id,
    required this.placedAt,
    required this.items,
    required this.total,
    this.deliveryLat,
    this.deliveryLng,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'placedAt': placedAt.toIso8601String(),
    'items': items.map((i) => i.toJson()).toList(),
    'total': total,
    'deliveryLat': deliveryLat,
    'deliveryLng': deliveryLng,
  };

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      placedAt: DateTime.parse(json['placedAt'] as String),
      items: (json['items'] as List)
          .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toDouble(),
      deliveryLat: (json['deliveryLat'] as num?)?.toDouble(),
      deliveryLng: (json['deliveryLng'] as num?)?.toDouble(),
    );
  }
}
