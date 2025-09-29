import '../../models/cart_item.dart';

class CartManager {
  final Map<String, CartItem> _item ={
    'p1': CartItem(
      id: 'c1',
      title: 'Red Shirt',
      quantity: 1,
      price: 29.99,
      imageUrl: 'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
  };

  int get productCount {
    return _item.length;
  }

  List<CartItem> get products {
    return _item.values.toList();
  }

  Iterable<MapEntry<String, CartItem>> get productEntries {
    return {..._item}.entries;
  }

  double get totalAmount {
    var total = 0.0;
    _item.forEach((key, cartItem) => total += cartItem.price * cartItem.quantity);
    return total;
  }

}