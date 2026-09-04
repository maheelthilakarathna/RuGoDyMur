import '../../models/cart_item.dart';
import '../local/local_db.dart';

/// Reads/writes the persisted cart for the given user id as a single Hive
/// entry (a JSON-shaped list of cart line items).
class CartRepository {
  List<CartItem> loadCart(String userId) {
    final raw = LocalDb.cartBox.get(userId);
    if (raw == null) return [];
    final list = List<Map>.from(raw as List);
    return list
        .map((e) => CartItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> saveCart(String userId, List<CartItem> items) async {
    await LocalDb.cartBox.put(userId, items.map((i) => i.toJson()).toList());
  }

  Future<void> clearCart(String userId) async {
    await LocalDb.cartBox.delete(userId);
  }
}
