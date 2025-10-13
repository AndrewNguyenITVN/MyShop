import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/cart_item.dart';
import 'cart_manager.dart';
import '../shared/dialog_utils.dart';

class CartItemCard extends StatelessWidget {
  final CartItem cartItem;
  final String productId;

  const CartItemCard({
    required this.cartItem,
    required this.productId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cartItem.id),
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: const Icon(Icons.delete, color: Colors.white, size: 40),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction){
        return showConfirmDialog(
          context,
          'Do you want to remove the item from the cart?',
        );
      },
      onDismissed: (direction){
        context.read<CartManager>().removeItem(productId);
      },
      child: ItemInfoCard(cartItem: cartItem),

    );
  }
}

class ItemInfoCard extends StatelessWidget {
  const ItemInfoCard({required this.cartItem, super.key});
  final CartItem cartItem;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.network(cartItem.imageUrl, fit: BoxFit.cover, height: 80, width: 80,),
          ),
          title: Text(cartItem.title),
          subtitle: Text('Total: \$${cartItem.price * cartItem.quantity}'),
          trailing: Text(
            '${cartItem.quantity} x \$${cartItem.price}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
    );
  }


}