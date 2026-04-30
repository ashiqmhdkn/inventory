import 'package:flutter/material.dart';
import 'package:flutter_inventory/models/admin.dart';
import 'package:flutter_inventory/models/item.dart';
import 'package:flutter_inventory/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/main_shell.dart';
import './providers/hive_provider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(ItemAdapter());
  Hive.registerAdapter(AdminAdapter());
  final box = await Hive.openBox<Item>('itemBox');
  final adminBox = await Hive.openBox<Admin>('adminBox');

  runApp(
    ProviderScope(
      overrides: [
        hiveBoxProvider.overrideWithValue(box),
        adminBoxProvider.overrideWithValue(adminBox), // ✅ inject
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const MainShell(),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter_inventory/providers/item_provider.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'models/item.dart';
// import 'screens/main_shell.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // await Hive.initFlutter();
//   // Hive.registerAdapter(ItemAdapter());
//   // final box = await Hive.openBox<Item>('items');

//   runApp(
//     const ProviderScope(
//       // overrides: [
//       //   hiveBoxProvider.overrideWithValue(box), // ✅ inject
//       // ],
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData.dark(),
//       home: const MainShell(),
//     );
//   }
// }
