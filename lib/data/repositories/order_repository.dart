import '../../models/order.dart';
import '../local/local_db.dart';

/// Reads/writes each user's order history as a list under their user id key.
class OrderRepository {
  List<Order> loadOrders(String userId) {
    final raw = LocalDb.ordersBox.get(userId);
    if (raw == null) return [];
    final list = List<Map>.from(raw as List);
    return list
        .map((e) => Order.fromJson(Map<String, dynamic>.from(e)))
        .toList()
        .reversed
        .toList();
  }

  Future<void> addOrder(String userId, Order order) async {
    final raw = LocalDb.ordersBox.get(userId);
    final list = raw == null ? <Map>[] : List<Map>.from(raw as List);
    list.add(order.toJson());
    await LocalDb.ordersBox.put(userId, list);
  }
}
