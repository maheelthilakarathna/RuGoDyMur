import '../../models/product.dart';
import '../../utils/constants.dart';
import 'api_client.dart';

/// Fetches the product catalogue from this project's own Laravel + MongoDB
/// API (see ~/Desktop/rugodymur-api). This is the app's "external JSON
/// file" data source, distinct from the bundled local asset used as an
/// offline fallback by ProductRepository.
class ProductRemoteSource {
  final ApiClient _client;

  ProductRemoteSource({ApiClient? client}) : _client = client ?? ApiClient();

  Future<List<Product>> fetchProducts() async {
    final data = await _client.getJson('${AppConstants.apiBaseUrl}/products');
    return (data as List)
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
