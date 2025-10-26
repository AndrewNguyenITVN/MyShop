import 'package:pocketbase/pocketbase.dart';
import '../models/order_item.dart';
import '../models/cart_item.dart';
import 'pocketbase_client.dart';

class OrdersService {
  // Create a new order in PocketBase
  Future<OrderItem> createOrder(double amount, List<CartItem> products) async {
    final pb = await getPocketbaseInstance();
    
    if (pb.authStore.record == null) {
      throw Exception('User not authenticated');
    }

    final userId = pb.authStore.record!.id;
    
    final orderData = {
      'userId': userId,
      'amount': amount,
      'products': products.map((item) => item.toMap()).toList(),
      'dateTime': DateTime.now().toIso8601String(),
    };

    try {
      final record = await pb.collection('orders').create(body: orderData);
      return OrderItem.fromJson({
        'id': record.id,
        ...record.toJson(),
      });
    } catch (error) {
      if (error is ClientException) {
        throw Exception(error.response['message']);
      }
      throw Exception('Failed to create order');
    }
  }

  Future<List<OrderItem>> fetchOrders() async {
    final pb = await getPocketbaseInstance();
    
    if (pb.authStore.record == null) {
      throw Exception('User not authenticated');
    }

    try {

      final records = await pb.collection('orders').getFullList(
        sort: '-created',
      );      
      final orders = <OrderItem>[];
      for (var record in records) {
        try {
          final json = record.toJson();          
          final order = OrderItem.fromJson({
            'id': record.id,
            ...json,
          });
          orders.add(order);
        } catch (e) {
          print('Error parsing order ${record.id}: $e');
        }
      }
      
      return orders;
    } catch (error) {
      print('Error fetching orders: $error');
      if (error is ClientException) {
        print('ClientException response: ${error.response}');
        throw Exception(error.response['message'] ?? 'Failed to fetch orders');
      }
      rethrow;
    }
  }
}

