class AppConstants {
  AppConstants._();

  // Fill this in once you've pushed this repo to GitHub, e.g.
  // 'https://raw.githubusercontent.com/<your-username>/<your-repo>/main/assets/data/products.json'
  // Until then (or if unreachable/offline) ProductRepository falls back to the
  // bundled asset at assets/data/products.json automatically.
  static const String remoteProductsJsonUrl = '';

  static const String dogRandomImageApi =
      'https://dog.ceo/api/breeds/image/random';
  static const String catFactApi = 'https://catfact.ninja/fact';

  static const String localProductsAsset = 'assets/data/products.json';
  static const String localCategoriesAsset = 'assets/data/categories.json';
}
