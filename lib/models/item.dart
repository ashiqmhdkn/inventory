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

  Item({
    required this.id,
    required this.title,
    this.image,
    required this.price,
    this.mrpPrice,
    this.stock,
  });

  Item copyWith({
    String? id,
    String? title,
    String? image,
    double? price,
    double? mrpPrice,
    int? stock,
  }) {
    return Item(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
      price: price ?? this.price,
      mrpPrice: mrpPrice ?? this.mrpPrice,
      stock: stock ?? this.stock,
    );
  }
}