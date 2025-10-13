class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String imageUrl;
  final String? size;
  final String? color;


CartItem({
  required this.id,
  required this.title,
  required this.quantity,
  required this.price,
  required this.imageUrl,
  this.size,
  this.color,
});

CartItem copyWith({
  String? id,
  String? title,
  int? quantity,
  double? price,
  String? imageUrl,
  String? size,
  String? color,
}) {
  return CartItem(
    id: id ?? this.id,
    title: title ?? this.title,
    quantity: quantity ?? this.quantity,
    price: price ?? this.price,
    imageUrl: imageUrl ?? this.imageUrl,
    size: size ?? this.size,
    color: color ?? this.color,
  );
}
}