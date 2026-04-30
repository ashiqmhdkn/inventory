// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:provider/provider.dart';
// import 'models/item.dart';
// // import 'models/item.g.dart';
// import 'providers/item_provider.dart';
// import 'screens/main_shell.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Hive.initFlutter();
//   Hive.registerAdapter(ItemAdapter());

//   final itemProvider = ItemProvider();
//   await itemProvider.init(); // ← must complete before runApp

//   runApp(
//     ChangeNotifierProvider.value(
//       value: itemProvider,
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
import 'package:flutter/material.dart';
import 'package:flutter_inventory/providers/item_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/item.dart';
import 'screens/main_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(ItemAdapter());
  final box = await Hive.openBox<Item>('items');

  runApp(
    ProviderScope(
      overrides: [
        hiveBoxProvider.overrideWithValue(box), // ✅ inject
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
