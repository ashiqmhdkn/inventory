// import 'package:flutter/material.dart';
// // import 'package:flutter_inventory/models/apiitem.dart';
// import 'package:flutter_inventory/models/item.dart';
// import 'package:flutter_inventory/screens/item_detail_screen.dart';
// import 'package:flutter_inventory/widgets/item_card.dart';
// import 'package:provider/provider.dart';
// // import '../models/item.dart';
// import '../providers/item_provider.dart';
// import '../widgets/item_form_dialog.dart';
// // import 'item_detail_screen.dart'

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   String _query = '';

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

// //  Future<void> _openAdd(BuildContext context) async {
// //   final result = await showModalBottomSheet<Map<String, dynamic>>(
// //     context: context,
// //     isScrollControlled: true,
// //     shape: const RoundedRectangleBorder(
// //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
// //     ),
// //     builder: (_) => const ItemFormBottomSheet(),
// //   );

// //   if (result != null && context.mounted) {
// //     await context.read<ItemProvider>().addItem(
// //           title: result['title'],
// //           tempImagePath: result['image'],
// //           price: result['price'],
// //           stock: result['stock'],
// //         );
// //   }
// // }

// // Future<void> _openEdit(BuildContext context, Item item) async {
// //   final result = await showModalBottomSheet<Map<String, dynamic>>(
// //     context: context,
// //     isScrollControlled: true,
// //     builder: (_) => ItemFormBottomSheet(item: item),
// //   );

// //   if (result != null && context.mounted) {
// //     await context.read<ItemProvider>().updateItem(
// //           id: item.id,
// //           title: result['title'],
// //           imagePath: result['image'],
// //           price: result['price'],
// //           stock: result['stock'],
// //         );
// //   }
// // }
// //   Future<void> _confirmDelete(BuildContext context, Item item) async {
// //     final provider = context.read<ItemProvider>();
// //     final confirmed = await showDialog<bool>(
// //       context: context,
// //       builder: (_) => AlertDialog(
// //         backgroundColor: const Color(0xFF1e1e21),
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// //         title: const Text('Remove item?',
// //             style: TextStyle(color: Colors.white, fontSize: 16)),
// //         content: Text(
// //           'Delete "${item.title}" from inventory?',
// //           style: const TextStyle(color: Color(0xFF888888)),
// //         ),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(context, false),
// //             child: const Text('Cancel',
// //                 style: TextStyle(color: Color(0xFF555555))),
// //           ),
// //           TextButton(
// //             onPressed: () => Navigator.pop(context, true),
// //             child: const Text('Delete',
// //                 style: TextStyle(color: Color(0xFFf87171))),
// //           ),
// //         ],
// //       ),
// //     );
// //     if (confirmed == true) provider.deleteItem(item.id);
// //   }

// Future<void> _openAdd(BuildContext context) async {
//   final result = await showModalBottomSheet<Map<String, dynamic>>(
//     context: context,
//     isScrollControlled: true,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//     ),
//     builder: (_) => const ItemFormBottomSheet(),
//   );

//   if (result != null && context.mounted) {
//     await context.read<ItemProvider>().addItem(
//       title: result['title'] as String,
//       tempImagePath: result['image'] as String?,
//       price: (result['price'] as num).toDouble(),
//       stock: result['stock'] as int?,
//       isMarket: result['isMarket'] as bool? ?? false,
//     );
//   }
// }

// Future<void> _openEdit(BuildContext context, Item item) async {
//   final result = await showModalBottomSheet<Map<String, dynamic>>(
//     context: context,
//     isScrollControlled: true,
//     builder: (_) => ItemFormBottomSheet(item: item),
//   );

//   if (result != null && context.mounted) {
//     await context.read<ItemProvider>().updateItem(
//       id: item.id,
//       title: result['title'] as String,
//       imagePath: result['image'] as String?,
//       price: (result['price'] as num).toDouble(),
//       stock: result['stock'] as int?,
//       isMarket: result['isMarket'] as bool? ?? item.isMarket,
//     );
//   }
// }

// Future<void> _confirmDelete(BuildContext context, Item item) async {
//   final provider = context.read<ItemProvider>();

//   final confirmed = await showDialog<bool>(
//     context: context,
//     builder: (_) => AlertDialog(
//       backgroundColor: const Color(0xFF1e1e21),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       title: const Text(
//         'Remove item?',
//         style: TextStyle(color: Colors.white, fontSize: 16),
//       ),
//       content: Text(
//         'Delete "${item.title}" from inventory?',
//         style: const TextStyle(color: Color(0xFF888888)),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context, false),
//           child: const Text(
//             'Cancel',
//             style: TextStyle(color: Color(0xFF555555)),
//           ),
//         ),
//         TextButton(
//           onPressed: () => Navigator.pop(context, true),
//           child: const Text(
//             'Delete',
//             style: TextStyle(color: Color(0xFFf87171)),
//           ),
//         ),
//       ],
//     ),
//   );

//   if (confirmed == true) {
//     await provider.deleteItem(item.id);
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0e0e10),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF0e0e10),
//         surfaceTintColor: Colors.transparent,
//         elevation: 0,
//         titleSpacing: 16,
//         title: Row(
//           children: [
//             Container(
//               width: 8,
//               height: 8,
//               decoration: const BoxDecoration(
//                 color: Color(0xFF1D9E75),
//                 shape: BoxShape.circle,
//               ),
//             ),
//             const SizedBox(width: 8),
//             const Text(
//               'Store',
//               style: TextStyle(
//                 fontFamily: 'Syne',
//                 fontWeight: FontWeight.w800,
//                 fontSize: 20,
//                 color: Color(0xFFf0f0f0),
//                 letterSpacing: -0.3,
//               ),
//             ),
//           ],
//         ),
//         // actions: [
//         //   Padding(
//         //     padding: const EdgeInsets.only(right: 12),
//         //     child: _CircleIconButton(
//         //       icon: Icons.add,
//         //       onTap: () => _openAdd(context),
//         //     ),
//         //   ),
//         // ],
//       ),
//       body: Consumer<ItemProvider>(
//         builder: (context, provider, _) {
//           final allItems = provider.items;
//           final items = _query.isEmpty
//               ? allItems
//               : allItems
//                   .where((it) =>
//                       it.title.toLowerCase().contains(_query.toLowerCase()))
//                   .toList();

//           return CustomScrollView(
//             slivers: [
//               // Search bar
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(14, 4, 14, 14),
//                   child: Container(
//                     height: 42,
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF161618),
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: const Color(0xFF2a2a2e)),
//                     ),
//                     child: Row(
//                       children: [
//                         const SizedBox(width: 12),
//                         const Icon(Icons.search_rounded,
//                             size: 18, color: Color(0xFF444444)),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: TextField(
//                             controller: _searchController,
//                             style: const TextStyle(
//                                 fontSize: 14, color: Color(0xFFcccccc)),
//                             onChanged: (v) => setState(() => _query = v),
//                             decoration: const InputDecoration(
//                               hintText: 'Search items…',
//                               hintStyle:
//                                   TextStyle(color: Color(0xFF444444), fontSize: 14),
//                               border: InputBorder.none,
//                               isDense: true,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),

//               // Section label
//               if (items.isNotEmpty)
//                 SliverPadding(
//                   padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
//                   sliver: SliverToBoxAdapter(
//                     child: Text(
//                       _query.isEmpty
//                           ? 'All items  ·  ${items.length}'
//                           : 'Results  ·  ${items.length}',
//                       style: const TextStyle(
//                         fontSize: 11,
//                         color: Color(0xFF444444),
//                         letterSpacing: 0.06,
//                       ),
//                     ),
//                   ),
//                 ),

//               // Empty state
//               if (items.isEmpty)
//                 SliverFillRemaining(
//                   child: Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Container(
//                           width: 64,
//                           height: 64,
//                           decoration: BoxDecoration(
//                             color: const Color(0xFF161618),
//                             shape: BoxShape.circle,
//                             border: Border.all(color: const Color(0xFF2a2a2e)),
//                           ),
//                           child: const Icon(Icons.inventory_2_outlined,
//                               size: 28, color: Color(0xFF444444)),
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           _query.isEmpty ? 'No items yet' : 'No results',
//                           style: const TextStyle(
//                             color: Color(0xFF888888),
//                             fontSize: 15,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const SizedBox(height: 6),
//                         Text(
//                           _query.isEmpty
//                               ? 'Tap + to add your first item'
//                               : 'Try a different search term',
//                           style: const TextStyle(
//                               color: Color(0xFF444444), fontSize: 13),
//                         ),
//                         if (_query.isEmpty) ...[
//                           const SizedBox(height: 20),
//                           _AddButton(onTap: () => _openAdd(context)),
//                         ]
//                       ],
//                     ),
//                   ),
//                 )
//               else
//                 SliverPadding(
//   padding: const EdgeInsets.fromLTRB(12, 0, 12, 100),
//   sliver: SliverList(
//     delegate: SliverChildBuilderDelegate(
//       (context, index) {
//         final item = items[index];
//         return ItemTile(
//           item: item,
//           onTap: () {
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (_) => ItemDetailScreen(item: item),
//     ),
//   );
// },

//           onEdit: () => _openEdit(context, item),
//           onDelete: () => _confirmDelete(context, item),
//         );
//       },
//       childCount: items.length,
//     ),
//   ),
// ),
//             ],
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () => _openAdd(context),
//         backgroundColor: const Color(0xFF1D9E75),
//         foregroundColor: Colors.white,
//         elevation: 0,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         icon: const Icon(Icons.add, size: 18),
//         label: const Text(
//           'Add item',
//           style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//         ),
//       ),
//     );
//   }
// }

// // ─── Small helpers ────────────────────────────────────────────────────────────

// class _CircleIconButton extends StatelessWidget {
//   final IconData icon;
//   final VoidCallback onTap;
//   const _CircleIconButton({required this.icon, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 34,
//         height: 34,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: const Color(0xFF1a1a1c),
//           border: Border.all(color: const Color(0xFF2a2a2e)),
//         ),
//         child: Icon(icon, size: 16, color: const Color(0xFF888888)),
//       ),
//     );
//   }
// }

// class _AddButton extends StatelessWidget {
//   final VoidCallback onTap;
//   const _AddButton({required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         decoration: BoxDecoration(
//           color: const Color(0xFF1D9E75),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: const Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(Icons.add, size: 16, color: Colors.white),
//             SizedBox(width: 6),
//             Text('Add item',
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 13,
//                     fontWeight: FontWeight.w500)),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../models/item.dart';
// import '../providers/item_provider.dart';
// import '../screens/item_detail_screen.dart';
// import '../widgets/item_card.dart';
// import '../widgets/item_form_dialog.dart';

// class HomeScreen extends ConsumerStatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   ConsumerState<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends ConsumerState<HomeScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   String _query = '';

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   // ---------------- ADD ----------------
//   Future<void> _openAdd() async {
//     final result = await showModalBottomSheet<Item>(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (_) => const ItemFormBottomSheet(),
//     );

//     if (result != null && mounted) {
//       print("........................1..................");
//       await ref.read(itemsProvider.notifier).addItem(
//             title: result.title,
//             tempImagePath: result.image,
//             price: (result.price as num).toDouble(),
//             stock: result.stock,
//             isMarket: result.isMarket as bool? ?? false,
//           );
//       print("........................2..................");
//       print(result.title);
//       print(result.image);
//       print(result.price);
//       print(result.stock);
//       print(result.mrpPrice);
//     }
//   }

//   // ---------------- EDIT ----------------
//   Future<void> _openEdit(Item item) async {
//     final result = await showModalBottomSheet<Item>(
//       context: context,
//       isScrollControlled: true,
//       builder: (_) => ItemFormBottomSheet(item: item),
//     );
//     if (result != null && mounted) {
//       await ref.read(itemsProvider.notifier).updateItem(
//             id: item.id,
//             title: result.title,
//             imagePath: result.image,
//             price: result.price,
//             stock: result.stock,
//             isMarket: result.isMarket,
//           );

//       // if (result != null && mounted) {
//       //   await ref.read(itemsProvider.notifier).updateItem(
//       //         id: item.id,
//       //         title: result['title'] as String,
//       //         imagePath: result['image'] as String?,
//       //         price: (result['price'] as num).toDouble(),
//       //         stock: result['stock'] as int?,
//       //         isMarket: result['isMarket'] as bool? ?? item.isMarket,
//       //       );
//     }
//   }

//   // ---------------- DELETE ----------------
//   Future<void> _confirmDelete(Item item) async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (_) => AlertDialog(
//         backgroundColor: const Color(0xFF1e1e21),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text(
//           'Remove item?',
//           style: TextStyle(color: Colors.white, fontSize: 16),
//         ),
//         content: Text(
//           'Delete "${item.title}" from inventory?',
//           style: const TextStyle(color: Color(0xFF888888)),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('Cancel',
//                 style: TextStyle(color: Color(0xFF555555))),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, true),
//             child: const Text('Delete',
//                 style: TextStyle(color: Color(0xFFf87171))),
//           ),
//         ],
//       ),
//     );

//     if (confirmed == true) {
//       await ref.read(itemsProvider.notifier).deleteItem(item.id);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final itemsAsync = ref.watch(itemsProvider);

//     return Scaffold(
//       backgroundColor: const Color(0xFF0e0e10),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF0e0e10),
//         elevation: 0,
//         title: const Text("Store"),
//       ),
//       body: itemsAsync.when(
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (e, _) => Center(child: Text("Error: $e")),
//         data: (allItems) {
//           final items = _query.isEmpty
//               ? allItems
//               : allItems
//                   .where((it) =>
//                       it.title.toLowerCase().contains(_query.toLowerCase()))
//                   .toList();

//           if (items.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.inventory_2_outlined,
//                       size: 40, color: Colors.grey),
//                   const SizedBox(height: 12),
//                   Text(
//                     _query.isEmpty ? 'No items yet' : 'No results',
//                     style: const TextStyle(color: Colors.grey),
//                   ),
//                 ],
//               ),
//             );
//           }

//           return ListView.builder(
//             padding: const EdgeInsets.only(bottom: 80),
//             itemCount: items.length,
//             itemBuilder: (context, index) {
//               final item = items[index];

//               return ItemTile(
//                 item: item,
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => ItemDetailScreen(item: item),
//                     ),
//                   );
//                 },
//                 onEdit: () => _openEdit(item),
//                 onDelete: () => _confirmDelete(item),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _openAdd,
//         backgroundColor: const Color(0xFF1D9E75),
//         icon: const Icon(Icons.add),
//         label: const Text("Add item"),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_inventory/repositories/item_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/item.dart';
import '../providers/item_provider.dart';
import '../screens/item_detail_screen.dart';
import '../widgets/item_card.dart';
import '../widgets/item_form_dialog.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ---------------- ADD ----------------
  Future<void> _openAdd() async {
    final result = await showModalBottomSheet<Item>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const ItemFormBottomSheet(),
    );

    if (result != null && mounted) {
      await ref.read(itemsProvider.notifier).addItem(
            title: result.title,
            tempImagePath: result.image,
            price: result.price,
            stock: result.stock,
            isMarket: result.isMarket,
          );
    }
  }

  // ---------------- EDIT ----------------
  Future<void> _openEdit(Item item) async {
    final result = await showModalBottomSheet<Item>(
      context: context,
      isScrollControlled: true,
      builder: (_) => ItemFormBottomSheet(item: item),
    );

    if (result != null && mounted) {
      await ref.read(itemsProvider.notifier).updateItem(
            id: item.id,
            title: result.title,
            imagePath: result.image,
            price: result.price,
            stock: result.stock,
            isMarket: result.isMarket,
          );
    }
  }

  // ---------------- DELETE ----------------
  Future<void> _confirmDelete(Item item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1e1e21),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Remove item?',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        content: Text(
          'Delete "${item.title}" from inventory?',
          style: const TextStyle(color: Color(0xFF888888)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel',
                style: TextStyle(color: Color(0xFF555555))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete',
                style: TextStyle(color: Color(0xFFf87171))),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(itemsProvider.notifier).deleteItem(item.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(itemsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0e0e10),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0e0e10),
        elevation: 0,
        title: const Text("Store"),
      ),
      body: Column(
        children: [
          // 🔍 SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: "Search items...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xFF161618),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 📦 LIST
          Expanded(
            child: itemsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text("Error: $e")),
              data: (allItems) {
                final items = _query.isEmpty
                    ? allItems
                    : allItems
                        .where((it) => it.title
                            .toLowerCase()
                            .contains(_query.toLowerCase()))
                        .toList();

                if (items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.inventory_2_outlined,
                            size: 40, color: Colors.grey),
                        const SizedBox(height: 12),
                        Text(
                          _query.isEmpty ? 'No items yet' : 'No results',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return ItemTile(
                      item: item,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ItemDetailScreen(item: item),
                          ),
                        );
                      },
                      onEdit: () => _openEdit(item),
                      onDelete: () => _confirmDelete(item),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAdd,
        backgroundColor: const Color(0xFF1D9E75),
        icon: const Icon(Icons.add),
        label: const Text("Add item"),
      ),
    );
  }
}
