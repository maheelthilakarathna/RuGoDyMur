import 'package:flutter/material.dart';

import '../../models/order.dart';
import '../../providers/nav_index_provider.dart';
import 'package:provider/provider.dart';
import '../../utils/theme.dart';
import '../home/main_shell.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final Order order;
  const OrderConfirmationScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 44,
                backgroundColor: AppColors.tint,
                child: Icon(Icons.check_circle, color: AppColors.coral, size: 48),
              ),
              const SizedBox(height: 24),
              Text('Order placed!', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text('Order #${order.id.substring(4)}', style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 4),
              Text('Total: \$${order.total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              if (order.deliveryLat != null && order.deliveryLng != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Delivering near ${order.deliveryLat!.toStringAsFixed(3)}, ${order.deliveryLng!.toStringAsFixed(3)}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  context.read<NavIndexProvider>().setIndex(0);
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const MainShell()),
                    (route) => false,
                  );
                },
                child: const Text('CONTINUE SHOPPING'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
