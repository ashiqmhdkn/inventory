import 'package:flutter_inventory/models/admin.dart';
import 'package:flutter_inventory/utils/hash_util.dart';
import 'package:hive/hive.dart';

class AuthRepository {
  final Box<Admin> box;

  AuthRepository(this.box);

  Future<void> initAdmin() async {
    if (box.isEmpty) {
      final admin = Admin(
        username: "admin",
        passwordHash: hashPassword("1234"),
      );
      await box.put("admin", admin);
    }
  }

  Future<bool> login(String username, String password) async {
    final admin = box.get("admin");

    if (admin == null) return false;

    return admin.username == username &&
        admin.passwordHash == hashPassword(password);
  }

  Future<void> changePassword(String newPassword) async {
    final admin = box.get("admin");

    if (admin != null) {
      admin.passwordHash = hashPassword(newPassword);
      await admin.save();
    }
  }

  Future<void> resetPassword() async {
    final admin = box.get("admin");

    if (admin != null) {
      admin.passwordHash = hashPassword("1234"); // default reset
      await admin.save();
    }
  }
}