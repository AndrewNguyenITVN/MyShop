import 'package:flutter/material.dart';

import 'products_grid.dart';

enum FillterOptions { favorites, all }

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();

}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _currentFilter = FillterOptions.all;

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
              print('Go to cart screen');
            },
          ),
        ],
      ),
      body: ProductsGrid(
        _currentFilter == FillterOptions.favorites,
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
    return IconButton(
      icon: const Icon(Icons.shopping_cart),
      onPressed: onPressed,
    );
  }
}
