import 'package:hive_flutter/hive_flutter.dart';

/// Thin wrapper around a handful of Hive boxes used as this app's local
/// (offline) data source. Each box stores plain JSON-shaped maps so no
/// generated type adapters are required.
class LocalDb {
  LocalDb._();

  static const usersBoxName = 'users_box';
  static const cartBoxName = 'cart_box';
  static const ordersBoxName = 'orders_box';
  static const favoritesBoxName = 'favorites_box';

  static late Box usersBox;
  static late Box cartBox;
  static late Box ordersBox;
  static late Box favoritesBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    usersBox = await Hive.openBox(usersBoxName);
    cartBox = await Hive.openBox(cartBoxName);
    ordersBox = await Hive.openBox(ordersBoxName);
    favoritesBox = await Hive.openBox(favoritesBoxName);
  }
}
