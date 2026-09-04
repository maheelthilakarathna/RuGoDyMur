import '../../models/product.dart';
import '../../utils/constants.dart';
import 'api_client.dart';

/// Fetches the product catalogue from an externally-hosted JSON file
/// (intended to be this project's own GitHub-raw URL once pushed — see
/// AppConstants.remoteProductsJsonUrl). This is distinct from the bundled
/// local asset used as an offline fallback by ProductRepository.
class ProductRemoteSource {
  final ApiClient _client;

  ProductRemoteSource({ApiClient? client}) : _client = client ?? ApiClient();

  Future<List<Product>> fetchProducts() async {
    if (AppConstants.remoteProductsJsonUrl.isEmpty) {
      throw ApiException('No remote products URL configured yet.');
    }
    final data = await _client.getJson(AppConstants.remoteProductsJsonUrl);
    return (data as List)
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
