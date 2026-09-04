import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../../models/category.dart';
import '../../models/product.dart';
import '../../utils/constants.dart';
import '../local/connectivity_service.dart';
import '../remote/product_remote_source.dart';

/// Product data source of truth: tries the externally-hosted JSON file
/// first, and falls back to the bundled local asset JSON whenever the
/// device is offline or the remote fetch fails for any reason. Categories
/// are always loaded from the bundled asset (they rarely change).
class ProductRepository {
  final ProductRemoteSource _remoteSource;
  final ConnectivityService _connectivity;

  ProductRepository({
    ProductRemoteSource? remoteSource,
    ConnectivityService? connectivity,
  }) : _remoteSource = remoteSource ?? ProductRemoteSource(),
       _connectivity = connectivity ?? ConnectivityService();

  Future<List<Product>> loadProducts() async {
    final online = await _connectivity.isOnline();
    if (online) {
      try {
        return await _remoteSource.fetchProducts();
      } catch (_) {
        // Fall through to the bundled local JSON below.
      }
    }
    return _loadLocalProducts();
  }

  Future<List<Product>> _loadLocalProducts() async {
    final raw = await rootBundle.loadString(AppConstants.localProductsAsset);
    final data = jsonDecode(raw) as List;
    return data.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Category>> loadCategories() async {
    final raw = await rootBundle.loadString(AppConstants.localCategoriesAsset);
    final data = jsonDecode(raw) as List;
    return data.map((e) => Category.fromJson(e as Map<String, dynamic>)).toList();
  }
}
