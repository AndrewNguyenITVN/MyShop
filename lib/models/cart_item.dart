class CartItem {
  final String id;
  final String productId; 
  final String title;
  final int quantity;
  final double price;
  final String imageUrl;
  final String? size;
  final String? color;


CartItem({
  required this.id,
  required this.productId,
  required this.title,
  required this.quantity,
  required this.price,
  required this.imageUrl,
  this.size,
  this.color,
});

CartItem copyWith({
  String? id,
  String? productId,
  String? title,
  int? quantity,
  double? price,
  String? imageUrl,
  String? size,
  String? color,
}) {
  return CartItem(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    title: title ?? this.title,
    quantity: quantity ?? this.quantity,
    price: price ?? this.price,
    imageUrl: imageUrl ?? this.imageUrl,
    size: size ?? this.size,
    color: color ?? this.color,
  );
}

// SQLite serialization
Map<String, dynamic> toMap() {
  return {
    'id': id,
    'product_id': productId,
    'title': title,
    'quantity': quantity,
    'price': price,
    'image_url': imageUrl,
    'size': size,
    'color': color,
  };
}

// SQLite deserialization
factory CartItem.fromMap(Map<String, dynamic> map) {
  return CartItem(
    id: map['id'] as String,
    productId: map['product_id'] as String,
    title: map['title'] as String,
    quantity: map['quantity'] as int,
    price: (map['price'] as num).toDouble(), // Handle both int and double
    imageUrl: map['image_url'] as String,
    size: map['size'] as String?,
    color: map['color'] as String?,
  );
}
}