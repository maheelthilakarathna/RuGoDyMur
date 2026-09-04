class AppConstants {
  AppConstants._();

  // Own Laravel + MongoDB API (see ~/Desktop/rugodymur-api), serving the
  // product/category catalogue as this app's "external JSON file" data
  // source. 127.0.0.1 reaches the host Mac directly from the iOS
  // Simulator; an Android emulator needs 10.0.2.2 instead, and a physical
  // device needs the Mac's LAN IP with both devices on the same network.
  // If unreachable/offline, ProductRepository falls back to the bundled
  // asset at assets/data/products.json automatically.
  static const String apiBaseUrl = 'http://127.0.0.1:8000/api';

  static const String dogRandomImageApi =
      'https://dog.ceo/api/breeds/image/random';
  static const String catFactApi = 'https://catfact.ninja/fact';

  static const String localProductsAsset = 'assets/data/products.json';
  static const String localCategoriesAsset = 'assets/data/categories.json';
}
