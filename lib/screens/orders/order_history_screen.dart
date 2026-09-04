import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';
import '../../utils/theme.dart';
import '../../widgets/empty_state.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<CartProvider>().orderHistory();
    final dateFormat = DateFormat('MMM d, yyyy · h:mm a');

    return Scaffold(
      appBar: AppBar(title: const Text('Order History')),
      body: orders.isEmpty
          ? const EmptyState(
              icon: Icons.receipt_long_outlined,
              title: 'No orders yet',
              message: 'Your placed orders will show up here.',
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final order = orders[index];
                return ExpansionTile(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.border)),
                  collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.border)),
                  title: Text('Order #${order.id.substring(4)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(dateFormat.format(order.placedAt)),
                  trailing: Text('\$${order.total.toStringAsFixed(2)}', style: const TextStyle(color: AppColors.coral, fontWeight: FontWeight.bold)),
                  children: order.items
                      .map((item) => ListTile(
                            dense: true,
                            leading: Icon(iconForName(item.product.icon), color: AppColors.navy),
                            title: Text(item.product.name),
                            subtitle: Text('${item.sizeLabel} · x${item.quantity}'),
                            trailing: Text('\$${item.lineTotal.toStringAsFixed(2)}'),
                          ))
                      .toList(),
                );
              },
            ),
    );
  }
}
