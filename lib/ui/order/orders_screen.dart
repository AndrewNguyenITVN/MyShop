import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'order_item_card.dart';
import 'order_manager.dart';
import '../shared/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //final ordersManager = OrdersManager();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const AppDrawer(),
      body: Consumer<OrdersManager>(
        builder: (_, ordersManager, __) {
          return ListView.builder(
            itemCount: ordersManager.orderCount,
            itemBuilder: (_, i) => OrderItemCard(order: ordersManager.orders[i]),
          );
        },
      ),
    );
  }
}
