import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/nav_index_provider.dart';
import '../../providers/product_provider.dart';
import '../../utils/theme.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final categories = productProvider.categories;

    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: categories.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.3,
              ),
              itemBuilder: (context, index) {
                final category = categories[index];
                final count = productProvider.filteredProducts.length;
                return InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    productProvider.selectCategory(category.id);
                    context.read<NavIndexProvider>().setIndex(0);
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                      color: AppColors.tint.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(iconForName(category.icon), size: 34, color: AppColors.navy),
                        const SizedBox(height: 10),
                        Text(category.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text('$count items', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
