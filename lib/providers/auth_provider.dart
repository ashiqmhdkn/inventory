import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/admin.dart';
import '../utils/hash_util.dart';

// Hive Box Provider
final adminBoxProvider = Provider<Box<Admin>>((ref) {
  return Hive.box<Admin>('adminBox');
});

// Auth State
class AuthState {
  final bool isAdmin;

  AuthState({required this.isAdmin});

  AuthState copyWith({bool? isAdmin}) {
    return AuthState(
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }
}

// Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final Box<Admin> box;

  AuthNotifier(this.box) : super(AuthState(isAdmin: false)) {
    _initAdmin();
  }

  // Create default admin
  Future<void> _initAdmin() async {
    if (box.isEmpty) {
      final admin = Admin(
        username: "admin",
        passwordHash: hashPassword("1234"),
      );
      await box.put("admin", admin);
    }
  }

  // LOGIN
  bool login(String username, String password) {
    final admin = box.get("admin");

    if (admin == null) return false;

    final success = admin.username == username &&
        admin.passwordHash == hashPassword(password);

    if (success) {
      state = state.copyWith(isAdmin: true);
    }

    return success;
  }

  // LOGOUT
  void logout() {
    state = state.copyWith(isAdmin: false);
  }

  // CHANGE PASSWORD
  Future<void> changePassword(String newPassword) async {
    final admin = box.get("admin");

    if (admin != null) {
      admin.passwordHash = hashPassword(newPassword);
      await admin.save();
    }
  }

  // RESET PASSWORD
  Future<void> resetPassword() async {
    final admin = box.get("admin");

    if (admin != null) {
      admin.passwordHash = hashPassword("1234");
      await admin.save();
    }
  }
}

// Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final box = ref.read(adminBoxProvider);
  return AuthNotifier(box);
});
