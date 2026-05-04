import 'package:hive/hive.dart';

part 'admin.g.dart';

@HiveType(typeId: 1)
class Admin extends HiveObject {
  @HiveField(0)
  String username;

  @HiveField(1)
  String passwordHash;

  @HiveField(2)
  bool isLoggedIn;

  Admin({
    required this.username,
    required this.passwordHash,
    this.isLoggedIn = false,
  });
}
