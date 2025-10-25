import 'package:flutter/foundation.dart';
import '../../models/cart_item.dart';
import '../../models/product.dart';
import '../../services/cart_service.dart';

class CartManager with ChangeNotifier {
  final CartService _cartService = CartService();
  String? _userId;
  
  final Map<String, CartItem> _item = {};

  CartManager();

  int get productCount {
    return _item.length;
  }

  List<CartItem> get products {
    return _item.values.toList();
  }

  Iterable<MapEntry<String, CartItem>> get productEntries {
    return {..._item}.entries;
  }

  double get totalAmount {
    var total = 0.0;
    _item.forEach((key, cartItem) => total += cartItem.price * cartItem.quantity);
    return total;
  }

  // Load cart from database for specific user
  Future<void> loadCartFromDatabase(String userId) async {
    _userId = userId;
    final items = await _cartService.getCartItems(userId);
    _item.clear();
    for (var item in items) {
      _item[item.productId] = item;
    }
    notifyListeners();
  }

  void addItem(Product product, {int quantity = 1, String? size, String? color}) async {
    if (_userId == null) return;

    CartItem cartItem;
    if (_item.containsKey(product.id)) {
      cartItem = _item[product.id]!.copyWith(quantity: _item[product.id]!.quantity + 1);
      _item[product.id!] = cartItem;
    } else {
      cartItem = CartItem(
        id: 'c${DateTime.now().toIso8601String()}',
        productId: product.id!,
        title: product.title, 
        quantity: quantity, 
        price: product.price, 
        imageUrl: product.imageUrl, 
        size: size ?? (product.sizes.isNotEmpty ? product.sizes[0] : null), 
        color: color ?? (product.colors.isNotEmpty ? product.colors[0] : null));
      _item[product.id!] = cartItem;
    }
    
    // Sync with database
    await _cartService.insertCartItem(_userId!, cartItem);
    notifyListeners();
  }

  void removeSingleItem(String productId) async {
    if (_userId == null || !_item.containsKey(productId)) {
      return;
    }
    if (_item[productId]!.quantity > 1) {
      final updatedItem = _item[productId]!.copyWith(quantity: _item[productId]!.quantity - 1);
      _item[productId] = updatedItem;
      await _cartService.updateCartItem(_userId!, updatedItem);
    } else {
      _item.remove(productId);
      await _cartService.deleteCartItem(_userId!, productId);
    }
    notifyListeners();
  }
  
  void removeItem(String productId) async {
    if (_userId == null || !_item.containsKey(productId)) {
      return;
    }
    if (_item[productId]!.quantity as num > 1) {
      final updatedItem = _item[productId]!.copyWith(quantity: _item[productId]!.quantity - 1);
      _item[productId] = updatedItem;
      await _cartService.updateCartItem(_userId!, updatedItem);
    } else {
      _item.remove(productId);
      await _cartService.deleteCartItem(_userId!, productId);
    }
    notifyListeners();
  }

  void clearItem(String productId) async {
    if (_userId == null) return;
    _item.remove(productId);
    await _cartService.deleteCartItem(_userId!, productId);
    notifyListeners();
  }

  void clearAllItem() async {
    if (_userId == null) return;
    _item.clear();
    await _cartService.clearCart(_userId!);
    notifyListeners();
  }
}