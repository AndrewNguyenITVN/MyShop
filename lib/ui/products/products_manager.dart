import 'package:flutter/foundation.dart';
import '../../models/product.dart';
import '../../services/products_service.dart';

class ProductsManager with ChangeNotifier{
  final ProductsService _productsService = ProductsService();
  List<Product> _items = [];

  int get itemCount {
    return _items.length;
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Product? findById(String id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> addProduct(Product product) async {
    final newProduct = await _productsService.addProduct(product);
    if (newProduct != null) {
    _items.add(newProduct);
    notifyListeners();
    }
  }

  void updateProduct(Product product) {
    final index = _items.indexWhere((item) => item.id == product.id);
    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }
  }
  
  void deleteProduct(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    _items.removeAt(index);
    notifyListeners();
  }

  Future<void> fetchProducts() async {
    print('ProductsManager: Starting fetchProducts');
    _items = await _productsService.fetchProducts();
    print('ProductsManager: Fetched ${_items.length} products');
    notifyListeners();
  }

  Future<void> fetchUserProducts() async {
    _items = await _productsService.fetchProducts(filterByUser: true);
    notifyListeners();
  }
}
