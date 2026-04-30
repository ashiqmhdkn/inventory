// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';

// // class ItemsScreen extends ConsumerWidget {
// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     final itemsAsync = ref.watch(itemsProvider);

// //     return Scaffold(
// //       appBar: AppBar(title: Text("Items")),
// //       body: itemsAsync.when(
// //         loading: () => Center(child: CircularProgressIndicator()),
// //         error: (err, _) => Center(child: Text("Error: $err")),
// //         data: (items) {
// //           if (items.isEmpty) {
// //             return Center(child: Text("No items"));
// //           }

// //           return ListView.builder(
// //             itemCount: items.length,
// //             itemBuilder: (context, i) {
// //               final item = items[i];

// //               return ListTile(
// //                 leading: item.image.isNotEmpty
// //                     ? Image.network(item.image, width: 50)
// //                     : null,
// //                 title: Text(item.name),
// //                 subtitle: Text("₹${item.price} | Qty: ${item.quantity}"),
// //               );
// //             },
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class ItemsScreen extends ConsumerWidget {
//   const ItemsScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final itemsAsync = ref.watch(itemsProvider);

//     return Scaffold(
//       appBar: AppBar(title: const Text("Items")),
//       body: itemsAsync.when(
//         loading: () =>
//             const Center(child: CircularProgressIndicator()),
//         error: (err, _) =>
//             Center(child: Text("Error: $err")),
//         data: (items) {
//           if (items.isEmpty) {
//             return const Center(child: Text("No items"));
//           }

//           return ListView.builder(
//             itemCount: items.length,
//             itemBuilder: (context, i) {
//               final item = items[i];

//               return ListTile(
//                 leading: (item.image != null &&
//                         item.image!.isNotEmpty)
//                     ? Image.network(
//                         item.image!,
//                         width: 50,
//                         height: 50,
//                         fit: BoxFit.cover,
//                         errorBuilder: (_, __, ___) =>
//                             const Icon(Icons.image_not_supported),
//                       )
//                     : const Icon(Icons.image),

//                 title: Text(item.title),

//                 subtitle: Text(
//                   "₹${item.price} | Qty: ${item.stock ?? 0}",
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/item_provider.dart';

class ItemsScreen extends ConsumerWidget {
  const ItemsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(itemProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Items")),
      body: itemsAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (err, _) =>
            Center(child: Text("Error: $err")),
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text("No items"));
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, i) {
              final item = items[i];

              return ListTile(
                leading: (item.image != null &&
                        item.image!.isNotEmpty)
                    ? Image.file(
                        File(item.image!),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.image),

                title: Text(item.title),

                subtitle: Text(
                  "₹${item.price} | Qty: ${item.stock ?? 0}",
                ),

                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    ref
                        .read(itemProvider.notifier)
                        .deleteItem(item.id);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}