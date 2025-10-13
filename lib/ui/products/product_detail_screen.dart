import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../cart/cart_screen.dart';
import '../cart/cart_manager.dart';
import '../shared/page_route_builder.dart';
import 'package:go_router/go_router.dart';
import '../products/products_overview_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen(
    this.product, {
    super.key,
  });

  final Product product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  // Biến trạng thái để lưu lựa chọn của người dùng
  int _quantity = 1;
  String? _selectedSize;
  String? _selectedColor;

  // Map để chuyển đổi tên màu thành đối tượng Color để hiển thị
  final Map<String, Color> _colorMap = {
    'Red': Colors.red,
    'Blue': Colors.blue,
    'Black': Colors.black,
    'White': Colors.white,
    'Green': Colors.green,
    'Yellow': Colors.yellow,
  };

  @override
  void initState() {
    super.initState();
    // Khởi tạo giá trị lựa chọn ban đầu từ dữ liệu sản phẩm
    if (widget.product.sizes.isNotEmpty) {
      _selectedSize = widget.product.sizes[0];
    }
    if (widget.product.colors.isNotEmpty) {
      _selectedColor = widget.product.colors[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.title),
        actions: <Widget>[
          // (1) Nút thêm vào Wishlist
          IconButton(
            icon: Icon(
              widget.product.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () {
              print('Toggle a favorite product');
            },
          ),
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
          // IconButton(
          //   icon: const Icon(Icons.shopping_cart),
          //   onPressed: () {
          //     Navigator.of(context).push(
          //       CustomPageRoute(
          //         child: const CartScreen(),
          //       ),
          //     );
          //   },
          // ),
          ShoppingCartButton(
            onPressed: () {
              context.push('/cart');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.network(
                widget.product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${widget.product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.product.description,
                    textAlign: TextAlign.justify,
                    softWrap: true,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),

                  // (2) Widget chọn Kích cỡ (Size)
                  _buildSizeSelector(),

                  const SizedBox(height: 24),

                  // (2) Widget chọn Màu sắc (Color)
                  _buildColorSelector(),

                  const SizedBox(height: 24),

                  // (2) Widget chọn Số lượng (Quantity)
                  _buildQuantitySelector(),
                ],
              ),
            ),
          ],
        ),
      ),
      // (3) Nút thêm vào Giỏ hàng (Add to Cart)
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SizedBox(
          height: 50,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.shopping_cart_outlined),
            label: const Text('Add to Cart'),
            onPressed: () {
              // TODO: Triển khai chức năng thêm vào giỏ hàng
              final cart = context.read<CartManager>();
              cart.addItem(widget.product, quantity: _quantity, size: _selectedSize, color: _selectedColor);
              print(
                  'Added to cart: ${widget.product.title}, Quantity: $_quantity, Size: $_selectedSize, Color: $_selectedColor');
              // ScaffoldMessenger.of(context).showSnackBar(
              //   const SnackBar(
              //     content: Text('Product added to cart!'),
              //     duration: Duration(seconds: 2),
              //   ),
              // );
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: const Text('Item added to cart'),
                    duration: const Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cart.removeSingleItem(widget.product.id!);
                      },
                    ),
                  ),
                );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget để xây dựng khu vực chọn kích cỡ
  Widget _buildSizeSelector() {
    // Dùng dữ liệu giả nếu product.sizes rỗng
    final sizes =
        widget.product.sizes;
    if (sizes.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Size', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          children: sizes.map((size) {
            return ChoiceChip(
              label: Text(size),
              selected: _selectedSize == size,
              onSelected: (selected) {
                setState(() {
                  _selectedSize = size;
                });
              },
              selectedColor: Theme.of(context).colorScheme.primary,
              labelStyle: TextStyle(
                color: _selectedSize == size ? Colors.white : Colors.black,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Widget để xây dựng khu vực chọn màu sắc
  Widget _buildColorSelector() {
    // Dùng dữ liệu giả nếu product.colors rỗng
    final colors = widget.product.colors;
    if (colors.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Color', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12.0,
          runSpacing: 12.0,
          children: colors.map((colorName) {
            final color = _colorMap[colorName] ?? Colors.grey;
            final isSelected = _selectedColor == colorName;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = colorName;
                });
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade300,
                    width: isSelected ? 3 : 1,
                  ),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withOpacity(0.5),
                        blurRadius: 5,
                        spreadRadius: 1,
                      )
                  ],
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 20)
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Widget để xây dựng khu vực chọn số lượng
  Widget _buildQuantitySelector() {
    return Row(
      children: <Widget>[
        Text('Quantity', style: Theme.of(context).textTheme.titleLarge),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  if (_quantity > 1) {
                    setState(() {
                      _quantity--;
                    });
                  }
                },
              ),
              Text(
                '$_quantity',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    _quantity++;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}