import 'package:flutter/foundation.dart';
import '../../models/order_item.dart';
import '../../models/cart_item.dart';
import '../../services/orders_service.dart';

class OrdersManager with ChangeNotifier {
  final OrdersService _ordersService = OrdersService();
  final List<OrderItem> _orders = [];

  OrdersManager();

  int get orderCount {
    return _orders.length;
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  // Fetch orders from PocketBase
  Future<void> fetchAndSetOrders() async {
    try {
      final orders = await _ordersService.fetchOrders();
      _orders.clear();
      _orders.addAll(orders);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  // Add order and save to PocketBase
  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    try {
      final newOrder = await _ordersService.createOrder(total, cartProducts);
      _orders.insert(0, newOrder);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}