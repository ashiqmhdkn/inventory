import 'package:hive/hive.dart';

part 'item.g.dart';

@HiveType(typeId: 0)
class Item extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String image; // absolute path on device

  @HiveField(3)
  late double price;

  @HiveField(4)
  late int stock;

  Item({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    required this.stock,
  });
}