import 'package:flutter/material.dart';

import '../data/repositories/cart_repository.dart';
import '../data/repositories/order_repository.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../models/product.dart';

/// Holds the current user's cart in memory, backed by CartRepository for
/// persistence (local read on load, local write on every mutation), and
/// hands off to OrderRepository when an order is placed.
class CartProvider extends ChangeNotifier {
  final CartRepository _cartRepository;
  final OrderRepository _orderRepository;
  String? _userId;

  List<CartItem> _items = [];

  CartProvider({CartRepository? cartRepository, OrderRepository? orderRepository})
    : _cartRepository = cartRepository ?? CartRepository(),
      _orderRepository = orderRepository ?? OrderRepository();

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, i) => sum + i.quantity);

  double get subtotal => _items.fold(0.0, (sum, i) => sum + i.lineTotal);

  void attachUser(String? userId) {
    _userId = userId;
    _items = userId == null ? [] : _cartRepository.loadCart(userId);
    notifyListeners();
  }

  Future<void> _persist() async {
    if (_userId == null) return;
    await _cartRepository.saveCart(_userId!, _items);
  }

  Future<void> addToCart(Product product, String sizeLabel, double unitPrice, {int quantity = 1}) async {
    final key = '${product.id}_$sizeLabel';
    final existingIndex = _items.indexWhere((i) => i.lineKey == key);
    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, sizeLabel: sizeLabel, unitPrice: unitPrice, quantity: quantity));
    }
    notifyListeners();
    await _persist();
  }

  Future<void> updateQuantity(String lineKey, int quantity) async {
    if (quantity <= 0) {
      _items.removeWhere((i) => i.lineKey == lineKey);
    } else {
      final index = _items.indexWhere((i) => i.lineKey == lineKey);
      if (index >= 0) _items[index].quantity = quantity;
    }
    notifyListeners();
    await _persist();
  }

  Future<void> removeItem(String lineKey) async {
    _items.removeWhere((i) => i.lineKey == lineKey);
    notifyListeners();
    await _persist();
  }

  Future<Order> checkout({double? deliveryLat, double? deliveryLng}) async {
    final order = Order(
      id: 'ord_${DateTime.now().millisecondsSinceEpoch}',
      placedAt: DateTime.now(),
      items: List.of(_items),
      total: subtotal,
      deliveryLat: deliveryLat,
      deliveryLng: deliveryLng,
    );
    if (_userId != null) {
      await _orderRepository.addOrder(_userId!, order);
    }
    _items = [];
    notifyListeners();
    await _persist();
    return order;
  }

  List<Order> orderHistory() {
    if (_userId == null) return [];
    return _orderRepository.loadOrders(_userId!);
  }
}
