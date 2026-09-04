class ProductSize {
  final String label;
  final double priceDelta;

  const ProductSize({required this.label, required this.priceDelta});

  factory ProductSize.fromJson(Map<String, dynamic> json) {
    return ProductSize(
      label: json['label'] as String,
      priceDelta: (json['priceDelta'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {'label': label, 'priceDelta': priceDelta};
}
