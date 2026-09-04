import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../providers/cart_provider.dart';
import '../../providers/product_provider.dart';
import '../../utils/theme.dart';
import '../../widgets/quantity_stepper.dart';
import '../../widgets/rating_stars.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;
  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _quantity = 1;
  String? _selectedSize;

  @override
  Widget build(BuildContext context) {
    final product = context.watch<ProductProvider>().byId(widget.productId);
    if (product == null) {
      return const Scaffold(body: Center(child: Text('Product not found')));
    }
    _selectedSize ??= product.sizes.isEmpty ? null : product.sizes.first.label;
    final unitPrice = product.price +
        (product.sizes.isEmpty
            ? 0
            : product.sizes.firstWhere((s) => s.label == _selectedSize).priceDelta);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isLandscape = constraints.maxWidth > constraints.maxHeight;
          return isLandscape
              ? _LandscapeLayout(
                  product: product,
                  quantity: _quantity,
                  selectedSize: _selectedSize,
                  unitPrice: unitPrice,
                  onQuantityChanged: (q) => setState(() => _quantity = q),
                  onSizeChanged: (s) => setState(() => _selectedSize = s),
                  onAddToCart: () => _addToCart(product, unitPrice),
                )
              : _PortraitLayout(
                  product: product,
                  quantity: _quantity,
                  selectedSize: _selectedSize,
                  unitPrice: unitPrice,
                  onQuantityChanged: (q) => setState(() => _quantity = q),
                  onSizeChanged: (s) => setState(() => _selectedSize = s),
                  onAddToCart: () => _addToCart(product, unitPrice),
                );
        },
      ),
    );
  }

  void _addToCart(Product product, double unitPrice) {
    context.read<CartProvider>().addToCart(
      product,
      _selectedSize ?? 'Standard',
      unitPrice,
      quantity: _quantity,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.name} added to cart')),
    );
  }
}

class _HeroPanel extends StatelessWidget {
  final Product product;
  final double height;
  const _HeroPanel({required this.product, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        children: [
          Container(color: AppColors.tint),
          Center(child: Icon(iconForName(product.icon), size: 96, color: AppColors.tintDeep)),
          Positioned(
            top: 16,
            left: 16,
            child: _CircleButton(icon: Icons.arrow_back, onTap: () => Navigator.of(context).pop()),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: Row(
              children: [
                _CircleButton(icon: Icons.share_outlined, onTap: () {}),
                const SizedBox(width: 8),
                _CircleButton(icon: Icons.favorite_border, onTap: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: CircleAvatar(
        radius: 18,
        backgroundColor: Colors.white,
        child: Icon(icon, color: AppColors.navy, size: 18),
      ),
    );
  }
}

class _DetailsBody extends StatelessWidget {
  final Product product;
  final int quantity;
  final String? selectedSize;
  final double unitPrice;
  final ValueChanged<int> onQuantityChanged;
  final ValueChanged<String> onSizeChanged;

  const _DetailsBody({
    required this.product,
    required this.quantity,
    required this.selectedSize,
    required this.unitPrice,
    required this.onQuantityChanged,
    required this.onSizeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(product.name, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 6),
        Text('\$${unitPrice.toStringAsFixed(2)}', style: const TextStyle(color: AppColors.coral, fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 8),
        RatingStars(rating: product.rating, reviewCount: product.reviewCount),
        const SizedBox(height: 14),
        Text(product.description, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 20),
        const Text('Quantity', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy)),
        const SizedBox(height: 8),
        QuantityStepper(quantity: quantity, onChanged: onQuantityChanged),
        if (product.sizes.isNotEmpty) ...[
          const SizedBox(height: 20),
          const Text('Size', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: product.sizes.map((size) {
              final selected = size.label == selectedSize;
              return ChoiceChip(
                label: Text(size.label),
                selected: selected,
                onSelected: (_) => onSizeChanged(size.label),
                selectedColor: AppColors.navy,
                labelStyle: TextStyle(color: selected ? Colors.white : AppColors.navy, fontWeight: FontWeight.bold),
                shape: const StadiumBorder(),
              );
            }).toList(),
          ),
        ],
        const SizedBox(height: 20),
        const Divider(),
        const SizedBox(height: 8),
        Text('Product Details', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        ...product.details.map(
          (d) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Icon(Icons.circle, size: 6, color: AppColors.coral),
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(d)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 90),
      ],
    );
  }
}

class _AddToCartBar extends StatelessWidget {
  final double unitPrice;
  final VoidCallback onAddToCart;
  const _AddToCartBar({required this.unitPrice, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: const Border(top: BorderSide(color: AppColors.border)),
        ),
        child: ElevatedButton(
          onPressed: onAddToCart,
          child: Text('ADD TO CART · \$${unitPrice.toStringAsFixed(2)}'),
        ),
      ),
    );
  }
}

class _PortraitLayout extends StatelessWidget {
  final Product product;
  final int quantity;
  final String? selectedSize;
  final double unitPrice;
  final ValueChanged<int> onQuantityChanged;
  final ValueChanged<String> onSizeChanged;
  final VoidCallback onAddToCart;

  const _PortraitLayout({
    required this.product,
    required this.quantity,
    required this.selectedSize,
    required this.unitPrice,
    required this.onQuantityChanged,
    required this.onSizeChanged,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeroPanel(product: product, height: 280),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: _DetailsBody(
                    product: product,
                    quantity: quantity,
                    selectedSize: selectedSize,
                    unitPrice: unitPrice,
                    onQuantityChanged: onQuantityChanged,
                    onSizeChanged: onSizeChanged,
                  ),
                ),
              ],
            ),
          ),
        ),
        _AddToCartBar(unitPrice: unitPrice * quantity, onAddToCart: onAddToCart),
      ],
    );
  }
}

class _LandscapeLayout extends StatelessWidget {
  final Product product;
  final int quantity;
  final String? selectedSize;
  final double unitPrice;
  final ValueChanged<int> onQuantityChanged;
  final ValueChanged<String> onSizeChanged;
  final VoidCallback onAddToCart;

  const _LandscapeLayout({
    required this.product,
    required this.quantity,
    required this.selectedSize,
    required this.unitPrice,
    required this.onQuantityChanged,
    required this.onSizeChanged,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(flex: 4, child: _HeroPanel(product: product, height: double.infinity)),
        Expanded(
          flex: 6,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: _DetailsBody(
                    product: product,
                    quantity: quantity,
                    selectedSize: selectedSize,
                    unitPrice: unitPrice,
                    onQuantityChanged: onQuantityChanged,
                    onSizeChanged: onSizeChanged,
                  ),
                ),
              ),
              _AddToCartBar(unitPrice: unitPrice * quantity, onAddToCart: onAddToCart),
            ],
          ),
        ),
      ],
    );
  }
}
