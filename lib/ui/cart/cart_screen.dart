import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../order/order_manager.dart';
import 'cart_manager.dart';
import 'cart_item_card.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<void> _fetchCart;

  @override
  void initState() {
    super.initState();
    _fetchCart = context.read<CartManager>().fetchCart();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartManager>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: FutureBuilder(
        future: _fetchCart,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: <Widget>[
              CartSummary(
                cart: cart, 
                onOrderNowPressed: cart.totalAmount <= 0 ? null : () {
                  context.read<OrdersManager>().addOrder(cart.products, cart.totalAmount);
                  cart.clearAllItem();
                } 
              ),
              const SizedBox(height: 10),
              Expanded(
                child: CartItemList(cart: cart),
              )
            ]
          );
        },
      )
    );
  }
}

class CartItemList extends StatelessWidget {
  const CartItemList({required this.cart, super.key});
  final CartManager cart;
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: cart.productEntries
        .map((entry) => CartItemCard(cartItem: entry.value, productId: entry.key)).toList(),
    );
  }
}


class CartSummary extends StatelessWidget {
  const CartSummary({super.key, required this.cart, this.onOrderNowPressed});
  final CartManager cart;
  final void Function()? onOrderNowPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text('Total', style: TextStyle(fontSize: 20)),
            const Spacer(),
            Chip(label: 
              Text('\$${cart.totalAmount.toStringAsFixed(2)}',
              style: Theme.of(context).primaryTextTheme.titleLarge),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            TextButton(
              onPressed: onOrderNowPressed,
              style: TextButton.styleFrom(
                textStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              child: const Text('Order Now'),
            ),
          ],
        ),
      ),

    );
  }
}