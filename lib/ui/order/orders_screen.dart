import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'order_item_card.dart';
import 'order_manager.dart';
import '../shared/app_drawer.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future<void> _fetchOrders;

  @override
  void initState() {
    super.initState();
    _fetchOrders = context.read<OrdersManager>().fetchAndSetOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _fetchOrders,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('An error occurred: ${snapshot.error}'),
            );
          } else {
            return Consumer<OrdersManager>(
              builder: (_, ordersManager, __) {
                if (ordersManager.orderCount == 0) {
                  return const Center(
                    child: Text('No orders yet!'),
                  );
                }
                return ListView.builder(
                  itemCount: ordersManager.orderCount,
                  itemBuilder: (_, i) => OrderItemCard(order: ordersManager.orders[i]),
                );
              },
            );
          }
        },
      ),
    );
  }
}
