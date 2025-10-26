import 'package:flutter/foundation.dart';
import '../../models/cart_item.dart';
import '../../models/product.dart';
import '../../services/cart_service.dart';
import '../../services/auth_service.dart';

class CartManager with ChangeNotifier {
  final CartService _cartService = CartService();
  final AuthService _authService = AuthService();
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

  Future<void> fetchCart() async {
    try {
      final userId = await _authService.getUserFromStore();
      if (userId == null) {
        _item.clear();
        notifyListeners();
        return;
      }

      final items = await _cartService.getCartItems(userId.id);
      _item.clear();
      for (var item in items) {
        _item[item.productId] = item;
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching cart: $e');
      rethrow;
    }
  }

  Future<void> addItem(Product product, {int quantity = 1, String? size, String? color}) async {
    try {
      final userId = await _authService.getUserFromStore();
      if (userId == null) {
        throw Exception('User not authenticated');
      }

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
      
      await _cartService.insertCartItem(userId.id, cartItem);
      notifyListeners();
    } catch (e) {
      print('Error adding item to cart: $e');
      rethrow;
    }
  }

  Future<void> removeSingleItem(String productId) async {
    try {
      final userId = await _authService.getUserFromStore();
      if (userId == null || !_item.containsKey(productId)) {
        return;
      }
      
      if (_item[productId]!.quantity > 1) {
        final updatedItem = _item[productId]!.copyWith(quantity: _item[productId]!.quantity - 1);
        _item[productId] = updatedItem;
        await _cartService.updateCartItem(userId.id, updatedItem);
      } else {
        _item.remove(productId);
        await _cartService.deleteCartItem(userId.id, productId);
      }
      notifyListeners();
    } catch (e) {
      print('Error removing single item: $e');
      rethrow;
    }
  }
  
  Future<void> removeItem(String productId) async {
    try {
      final userId = await _authService.getUserFromStore();
      if (userId == null || !_item.containsKey(productId)) {
        return;
      }
      
      if (_item[productId]!.quantity as num > 1) {
        final updatedItem = _item[productId]!.copyWith(quantity: _item[productId]!.quantity - 1);
        _item[productId] = updatedItem;
        await _cartService.updateCartItem(userId.id, updatedItem);
      } else {
        _item.remove(productId);
        await _cartService.deleteCartItem(userId.id, productId);
      }
      notifyListeners();
    } catch (e) {
      print('Error removing item: $e');
      rethrow;
    }
  }

  Future<void> clearItem(String productId) async {
    try {
      final userId = await _authService.getUserFromStore();
      if (userId == null) return;
      
      _item.remove(productId);
      await _cartService.deleteCartItem(userId.id, productId);
      notifyListeners();
    } catch (e) {
      print('Error clearing item: $e');
      rethrow;
    }
  }

  Future<void> clearAllItem() async {
    try {
      final userId = await _authService.getUserFromStore();
      if (userId == null) return;
      
      _item.clear();
      await _cartService.clearCart(userId.id);
      notifyListeners();
    } catch (e) {
      print('Error clearing cart: $e');
      rethrow;
    }
  }
}