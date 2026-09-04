import 'package:flutter/material.dart';

import '../data/repositories/product_repository.dart';
import '../models/category.dart';
import '../models/product.dart';

enum ProductLoadStatus { loading, loaded, error }

class ProductProvider extends ChangeNotifier {
  final ProductRepository _repository;

  ProductLoadStatus _status = ProductLoadStatus.loading;
  List<Product> _products = [];
  List<Category> _categories = [];
  String _selectedCategory = 'all';

  ProductProvider({ProductRepository? repository})
    : _repository = repository ?? ProductRepository() {
    load();
  }

  ProductLoadStatus get status => _status;
  List<Category> get categories => _categories;
  String get selectedCategory => _selectedCategory;

  List<Product> get filteredProducts {
    if (_selectedCategory == 'all') return _products;
    return _products.where((p) => p.category == _selectedCategory).toList();
  }

  Product? byId(String id) {
    for (final p in _products) {
      if (p.id == id) return p;
    }
    return null;
  }

  Future<void> load() async {
    _status = ProductLoadStatus.loading;
    notifyListeners();
    try {
      final results = await Future.wait([
        _repository.loadProducts(),
        _repository.loadCategories(),
      ]);
      _products = results[0] as List<Product>;
      _categories = results[1] as List<Category>;
      _status = ProductLoadStatus.loaded;
    } catch (_) {
      _status = ProductLoadStatus.error;
    }
    notifyListeners();
  }

  void selectCategory(String id) {
    _selectedCategory = id;
    notifyListeners();
  }
}
