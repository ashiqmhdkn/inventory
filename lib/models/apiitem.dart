class Item {
  final String id;
  final String title;
  final String image;
  final double price;
  final int stock;

  const Item({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    required this.stock,
  });

  Item copyWith({
    String? id,
    String? title,
    String? image,
    double? price,
    int? stock,
  }) {
    return Item(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
      price: price ?? this.price,
      stock: stock ?? this.stock,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'image': image,
        'price': price,
        'stock': stock,
      };

  factory Item.fromMap(Map<String, dynamic> map) => Item(
        id: map['id'] as String,
        title: map['title'] as String,
        image: map['image'] as String,
        price: (map['price'] as num).toDouble(),
        stock: map['stock'] as int,
      );
}
