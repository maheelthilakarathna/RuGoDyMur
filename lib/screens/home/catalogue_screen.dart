import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';
import '../../providers/product_provider.dart';
import '../../utils/theme.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/product_card.dart';
import '../pet_facts/pet_facts_screen.dart';
import '../product/product_details_screen.dart';

class CatalogueScreen extends StatelessWidget {
  const CatalogueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Rugodymur', style: Theme.of(context).textTheme.headlineSmall),
        actions: [
          IconButton(
            icon: const Icon(Icons.pets_outlined),
            tooltip: 'Pet facts',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PetFactsScreen()),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: productProvider.load,
        child: _buildBody(context, productProvider),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ProductProvider productProvider) {
    if (productProvider.status == ProductLoadStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (productProvider.status == ProductLoadStatus.error) {
      return EmptyState(
        icon: Icons.error_outline,
        title: 'Could not load products',
        message: 'Pull down to try again.',
      );
    }

    final chips = [
      const CategoryChipData('all', 'All'),
      ...productProvider.categories.map((c) => CategoryChipData(c.id, c.name)),
    ];
    final products = productProvider.filteredProducts;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        CategoryChipRow(
          chips: chips,
          selectedId: productProvider.selectedCategory,
          onSelect: productProvider.selectCategory,
        ),
        const SizedBox(height: 16),
        _PetFactCard(onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const PetFactsScreen()),
        )),
        const SizedBox(height: 16),
        if (products.isEmpty)
          const EmptyState(icon: Icons.search_off, title: 'No products here', message: 'Try another category.')
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.68,
            ),
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                product: product,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ProductDetailsScreen(productId: product.id)),
                ),
                onAdd: () {
                  final sizeLabel = product.sizes.isEmpty ? 'Standard' : product.sizes.first.label;
                  context.read<CartProvider>().addToCart(product, sizeLabel, product.price);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${product.name} added to cart'), duration: const Duration(milliseconds: 900)),
                  );
                },
              );
            },
          ),
      ],
    );
  }
}

class _PetFactCard extends StatelessWidget {
  final VoidCallback onTap;
  const _PetFactCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.navy,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const CircleAvatar(backgroundColor: Colors.white24, child: Icon(Icons.lightbulb, color: Colors.white)),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Did you know? Tap for a fun pet fact',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 14),
          ],
        ),
      ),
    );
  }
}
