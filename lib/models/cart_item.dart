import 'product.dart';

class CartItem {
  final Product product;
  final String sizeLabel;
  final double unitPrice;
  int quantity;

  CartItem({
    required this.product,
    required this.sizeLabel,
    required this.unitPrice,
    this.quantity = 1,
  });

  String get lineKey => '${product.id}_$sizeLabel';

  double get lineTotal => unitPrice * quantity;

  Map<String, dynamic> toJson() => {
    'product': product.toJson(),
    'sizeLabel': sizeLabel,
    'unitPrice': unitPrice,
    'quantity': quantity,
  };

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      sizeLabel: json['sizeLabel'] as String,
      unitPrice: (json['unitPrice'] as num).toDouble(),
      quantity: json['quantity'] as int,
    );
  }
}
