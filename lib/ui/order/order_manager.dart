import 'package:flutter/foundation.dart';
import '../../models/order_item.dart';
import '../../models/cart_item.dart';
import '../../services/orders_service.dart';

class OrdersManager with ChangeNotifier {
  final OrdersService _ordersService = OrdersService();
  List<OrderItem> _orders = [];

  OrdersManager();

  int get orderCount {
    return _orders.length;
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchUserOrders() async {
    try {
      _orders = await _ordersService.fetchOrders();
      notifyListeners();
    } catch (error) {
      print('Error fetching orders: $error');
      rethrow;
    }
  }


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