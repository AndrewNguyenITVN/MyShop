import 'package:flutter/material.dart';

import 'order_item_card.dart';
import 'order_manager.dart';
import '../shared/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderManager = OrderManager();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: orderManager.orderCount,
        itemBuilder: (ctx, i) => OrderItemCard(order: orderManager.orders[i]),
      ),
    );
  }
}
