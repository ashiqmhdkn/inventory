// class Item {
//   final String id;
//   final String title;
//   final String? image;
//   final double price;
//   final double mrpPrice;
//   final int? stock;
//   final String? category;

//   const Item({
//     required this.id,
//     required this.title,
//     this.image,
//     required this.price,
//     required this.mrpPrice,
//     this.stock,
//     this.category,
//   });

//   Item copyWith({
//     String? id,
//     String? title,
//     String? image,
//     double? price,
//     double? mrpPrice,
//     int? stock,
//     String? category,
//   }) {
//     return Item(
//       id: id ?? this.id,
//       title: title ?? this.title,
//       image: image ?? this.image,
//       price: price ?? this.price,
//       mrpPrice: mrpPrice ?? this.mrpPrice,
//       stock: stock ?? this.stock,
//       category: category ?? this.category,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'title': title,
//       'image': image,
//       'price': price,
//       'mrpPrice': mrpPrice,
//       'stock': stock,
//       'category': category,
//     };
//   }

//   factory Item.fromMap(Map map) {
//     return Item(
//       id: map['id'],
//       title: map['title'],
//       image: map['image'],
//       price: (map['price'] ?? 0).toDouble(),
//       mrpPrice: (map['mrpPrice'] ?? 0).toDouble(),
//       stock: map['stock'],
//       category: map['category'],
//     );
//   }
// }
class Item {
  final String id;
  final String title;
  final String? image;
  final double price;
  final double mrpPrice;
  final int? stock;
  final String? category;
  final bool isMarket;

  const Item({
    required this.id,
    required this.title,
    this.image,
    required this.price,
    required this.mrpPrice,
    this.stock,
    this.category,
    required this.isMarket,
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
      mrpPrice: mrpPrice ?? this.mrpPrice,
      stock: stock ?? this.stock,
      category: category ?? this.category,
      isMarket: isMarket ?? this.isMarket,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'price': price,
      'mrpPrice': mrpPrice,
      'stock': stock,
      'category': category,
      'isMarket': isMarket,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      title: map['title'],
      image: map['image'],
      price: (map['price'] ?? 0).toDouble(),
      mrpPrice: (map['mrpPrice'] ?? 0).toDouble(),
      stock: map['stock'],
      category: map['category'],
      isMarket: map['isMarket'] ?? false,
    );
  }
}
