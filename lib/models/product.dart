import 'dart:io';
class Product {
  final String? id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final bool isFavorite;
  final List<String> sizes;
  final List<String> colors;
  final File? featuredImage;
  Product({
    this.id,
    required this.title,
    required this.description,
    required this.price,
    this.imageUrl = '',
    this.isFavorite = false,
    this.sizes = const [],
    this.colors = const [],
    this.featuredImage,
  });

  Product copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? imageUrl,
    bool? isFavorite,
    List<String>? sizes,
    List<String>? colors,
    File? featuredImage,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
      sizes: sizes ?? this.sizes,
      colors: colors ?? this.colors,
      featuredImage: featuredImage ?? this.featuredImage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'isFavorite': isFavorite,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'],
      isFavorite: json['isFavorite'],
    );
  }

  bool hasFeaturedImage() {
    return featuredImage != null || imageUrl.isNotEmpty;
  }
}
