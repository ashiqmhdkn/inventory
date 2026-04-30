class Item {
  final String id;
  final String title;
  final String? image;
  final double price;
  final int? stock;

  const Item({
    required this.id,
    required this.title,
    this.image,
    required this.price,
    this.stock,
  });

  Item copyWith({
    String? id,
    String? title,
    String? image,
    double? price,
    double? mrpPrice,
    int? stock,
    String? category,
    bool? isMarket,
  }) {
    return Item(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
      price: price ?? this.price,
      stock: stock ?? this.stock,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'price': price,
      'stock': stock,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      title: map['name'],
      image: map['image'],
      price: (map['price'] ?? 0).toDouble(),
      stock: map['stock'],
    );
  }
}
