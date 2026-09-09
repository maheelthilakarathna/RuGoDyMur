class AppConstants {
  AppConstants._();

  // Own Laravel + MongoDB API (see ~/Desktop/rugodymur-api), serving the
  // product/category catalogue as this app's "external JSON file" data
  // source. Deployed on Railway (backed by MongoDB Atlas) so it's reachable
  // from any device, not just this Mac's local network. If unreachable/
  // offline, ProductRepository falls back to the bundled asset at
  // assets/data/products.json automatically.
  static const String apiBaseUrl =
      'https://rugodymur-api-production.up.railway.app/api';

  static const String dogRandomImageApi =
      'https://dog.ceo/api/breeds/image/random';
  static const String catFactApi = 'https://catfact.ninja/fact';

  static const String localProductsAsset = 'assets/data/products.json';
  static const String localCategoriesAsset = 'assets/data/categories.json';
}
