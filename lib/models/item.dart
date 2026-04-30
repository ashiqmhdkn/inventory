// // import 'package:hive/hive.dart';

// // part 'item.g.dart';

// // @HiveType(typeId: 0)
// // class Item extends HiveObject {
// //   @HiveField(0)
// //   String id;

// //   @HiveField(1)
// //   String title;

// //   @HiveField(2)
// //   String? image;

// //   @HiveField(3)
// //   double price;

// //   @HiveField(4)
// //   double? mrpPrice;

// //   @HiveField(5)
// //   int? stock;

// //   Item({
// //     required this.id,
// //     required this.title,
// //     this.image,
// //     required this.price,
// //     this.mrpPrice,
// //     this.stock,
// //   });

// //   Item copyWith({
// //     String? id,
// //     String? title,
// //     String? image,
// //     double? price,
// //     double? mrpPrice,
// //     int? stock,
// //   }) {
// //     return Item(
// //       id: id ?? this.id,
// //       title: title ?? this.title,
// //       image: image ?? this.image,
// //       price: price ?? this.price,
// //       mrpPrice: mrpPrice ?? this.mrpPrice,
// //       stock: stock ?? this.stock,
// //     );
// //   }
// // }
// // import 'package:hive/hive.dart';

// // part 'item.g.dart';

// // @HiveType(typeId: 0)
// // class Item extends HiveObject {
// //   @HiveField(0)
// //   String id;

// //   @HiveField(1)
// //   String title;

// //   @HiveField(2)
// //   String? image;

// //   @HiveField(3)
// //   double price;

// //   @HiveField(4)
// //   double? mrpPrice;

// //   @HiveField(5)
// //   int? stock;

// //   @HiveField(6)
// //   bool isMarket; // ✅ NEW FIELD (always use next index)

// //   Item({
// //     required this.id,
// //     required this.title,
// //     this.image,
// //     required this.price,
// //     this.mrpPrice,
// //     this.stock,
// //     required this.isMarket, // ✅ added
// //   });

// //   Item copyWith({
// //     String? id,
// //     String? title,
// //     String? image,
// //     double? price,
// //     double? mrpPrice,
// //     int? stock,
// //     bool? isMarket, // ✅ nullable for copyWith
// //   }) {
// //     return Item(
// //       id: id ?? this.id,
// //       title: title ?? this.title,
// //       image: image ?? this.image,
// //       price: price ?? this.price,
// //       mrpPrice: mrpPrice ?? this.mrpPrice,
// //       stock: stock ?? this.stock,
// //       isMarket: isMarket ?? this.isMarket, // ✅ fixed
// //     );
// //   }
// // }
// import 'package:hive/hive.dart';

// part 'item.g.dart';

// @HiveType(typeId: 0)
// class Item extends HiveObject {
//   @HiveField(0)
//   String id;

//   @HiveField(1)
//   String title;

//   @HiveField(2)
//   String? image;

//   @HiveField(3)
//   double price;

//   @HiveField(4)
//   double? mrpPrice;

//   @HiveField(5)
//   int? stock;

//   @HiveField(6)
//   bool isMarket;

//   Item({
//     required this.id,
//     required this.title,
//     this.image,
//     required this.price,
//     this.mrpPrice,
//     this.stock,
//     required this.isMarket,
//   });

//   Item copyWith({
//     String? id,
//     String? title,
//     String? image,
//     double? price,
//     double? mrpPrice,
//     int? stock,
//     bool? isMarket,
//   }) {
//     return Item(
//       id: id ?? this.id,
//       title: title ?? this.title,
//       image: image ?? this.image,
//       price: price ?? this.price,
//       mrpPrice: mrpPrice ?? this.mrpPrice,
//       stock: stock ?? this.stock,
//       isMarket: isMarket ?? this.isMarket,
//     );
//   }

//   // ✅ FROM JSON
//   factory Item.fromJson(Map<String, dynamic> json) {
//     return Item(
//       id: json['id']?.toString() ?? '',
//       title: json['title'] ?? json['name'] ?? '', // supports both
//       image: json['image'],
//       price: (json['price'] ?? 0).toDouble(),
//       mrpPrice: json['mrpPrice'] != null ? (json['mrpPrice']).toDouble() : null,
//       stock: json['stock'] ?? json['quantity'],
//       isMarket: json['isMarket'] ?? false,
//     );
//   }

//   // ✅ TO JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'title': title, // or 'name' depending on API
//       'image': image,
//       'price': price,
//       'mrpPrice': mrpPrice,
//       'stock': stock, // or 'quantity'
//       'isMarket': isMarket,
//     };
//   }
// }
import 'package:hive/hive.dart';

part 'item.g.dart';

@HiveType(typeId: 0)
class Item extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? image;

  @HiveField(3)
  double price;

  @HiveField(4)
  double? mrpPrice;

  @HiveField(5)
  int? stock;

  @HiveField(6)
  bool isMarket;

  Item({
    required this.id,
    required this.title,
    this.image,
    required this.price,
    this.mrpPrice,
    this.stock,
    required this.isMarket,
  });

  // ✅ FROM API → APP
  // factory Item.fromJson(Map<String, dynamic> json) {
  //   return Item(
  //     id: json['id'].toString(),
  //     title: json['name'] ?? '',
  //     image: json['image'],
  //     price: (json['price'] ?? 0).toDouble(),
  //     mrpPrice: null,
  //     stock: json['qty'],
  //     isMarket: true,
  //   );
  // }
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'].toString(),
      title: json['name'] ?? '',
      image: json['image'],
      price: (json['price'] ?? 0).toDouble(),
      mrpPrice: null,
      stock: json['qty'],
      isMarket: true,
    );
  }

  Map<String, String> toApiMap() {
    return {
      "id": id,
      "name": title,
      "price": price.toString(),
      "qty": (stock ?? 0).toString(),
    };
  }

  // ✅ FROM APP → API
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": title,
      "price": price,
      "qty": stock ?? 0,
      "image": image ?? "",
    };
  }

  Item copyWith({
    String? id,
    String? title,
    String? image,
    double? price,
    double? mrpPrice,
    int? stock,
    bool? isMarket,
  }) {
    return Item(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
      price: price ?? this.price,
      mrpPrice: mrpPrice ?? this.mrpPrice,
      stock: stock ?? this.stock,
      isMarket: isMarket ?? this.isMarket,
    );
  }
}
