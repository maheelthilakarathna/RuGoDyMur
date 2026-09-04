import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';
import '../../services/location_service.dart';
import '../../utils/theme.dart';
import 'order_confirmation_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _locationService = LocationService();
  LocationResult? _location;
  bool _fetchingLocation = false;
  bool _placingOrder = false;

  Future<void> _fetchLocation() async {
    setState(() => _fetchingLocation = true);
    final result = await _locationService.getCurrentLocation();
    if (!mounted) return;
    setState(() {
      _location = result;
      _fetchingLocation = false;
    });
    if (result == null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location unavailable — check permissions/settings.')),
      );
    }
  }

  Future<void> _placeOrder() async {
    setState(() => _placingOrder = true);
    final order = await context.read<CartProvider>().checkout(
      deliveryLat: _location?.latitude,
      deliveryLng: _location?.longitude,
    );
    if (!mounted) return;
    setState(() => _placingOrder = false);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => OrderConfirmationScreen(order: order)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Order summary', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...cart.items.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text('${item.product.name} x${item.quantity}')),
                  Text('\$${item.lineTotal.toStringAsFixed(2)}'),
                ],
              ),
            ),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('\$${cart.subtotal.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 24),
          Text('Delivery location', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                const Icon(Icons.location_on_outlined, color: AppColors.navy),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _location == null
                        ? 'No location set — use your current location for delivery.'
                        : 'Lat ${_location!.latitude.toStringAsFixed(4)}, Lng ${_location!.longitude.toStringAsFixed(4)}',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                TextButton(
                  onPressed: _fetchingLocation ? null : _fetchLocation,
                  child: _fetchingLocation
                      ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('USE GPS'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: (cart.items.isEmpty || _placingOrder) ? null : _placeOrder,
            child: _placingOrder
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('PLACE ORDER'),
          ),
        ],
      ),
    );
  }
}
