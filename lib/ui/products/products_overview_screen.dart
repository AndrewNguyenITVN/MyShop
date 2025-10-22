import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'products_grid.dart';
import 'package:go_router/go_router.dart';
import '../shared/app_drawer.dart';
import '../cart/cart_manager.dart';
import 'products_manager.dart';

enum FillterOptions { favorites, all }

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();

}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _currentFilter = FillterOptions.all;
  late Future<void> _fetchProducts;

  @override
  void initState() {
    super.initState();
    _fetchProducts = context.read<ProductsManager>().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: <Widget>[
          ProductFillterMenu(
            currentFilter: _currentFilter,
            onFilterSelected: (filter) {
              setState(() {
                _currentFilter = filter;
              });
            },
          ),
          ShoppingCartButton(
            onPressed: () {
              context.push('/cart');
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _fetchProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ProductsGrid(
              _currentFilter == FillterOptions.favorites,
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class ProductFillterMenu extends StatelessWidget {
  const ProductFillterMenu({super.key,
  this.currentFilter,
  this.onFilterSelected});

  final FillterOptions? currentFilter;
  final void Function(FillterOptions selectedValue)? onFilterSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      initialValue: currentFilter,
      onSelected: onFilterSelected,
      icon: const Icon(Icons.more_vert),
      itemBuilder: (ctx) => [
        const PopupMenuItem(
          value: FillterOptions.favorites,
          child: Text('Only Favorites'),
        ),
        const PopupMenuItem(
          value: FillterOptions.all,
          child: Text('Show All'),
        ),
      ],
    );
  }
}


class ShoppingCartButton extends StatelessWidget {
  const ShoppingCartButton({super.key, this.onPressed});

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Consumer<CartManager>(
      builder: (_, cartManager, __) {
        return IconButton(
          icon: Badge.count(
            count: cartManager.productCount,
            child: const Icon(Icons.shopping_cart),
          ),
          onPressed: onPressed,
        );
      }
    );
  }
}
