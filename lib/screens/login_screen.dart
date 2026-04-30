import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final userController = TextEditingController();
  final passController = TextEditingController();

  void _login() {
    final success = ref.read(authProvider.notifier).login(
          userController.text.trim(),
          passController.text.trim(),
        );

    if (success) {
      Navigator.pop(context); // go back to Home
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid username or password")),
      );
    }
  }

  void _resetPassword() async {
    await ref.read(authProvider.notifier).resetPassword();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Password reset to default: 1234")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0e0e10),
      appBar: AppBar(title: const Text("Admin Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: userController,
              decoration: const InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: passController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text("Login"),
            ),
            TextButton(
              onPressed: _resetPassword,
              child: const Text("Forgot Password?"),
            )
          ],
        ),
      ),
    );
  }
}
