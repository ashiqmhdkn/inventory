
import 'package:flutter/material.dart';
import 'package:flutter_inventory/providers/auth_provider.dart';
import 'package:flutter_inventory/models/apiitem.dart';
import 'package:flutter_inventory/screens/login_screen.dart';
import 'package:flutter_inventory/utils/item_ui_helper.dart';
import 'package:flutter_inventory/widgets/item_tile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
@override
void initState() {
  super.initState();
  Future.microtask(() {
    ref.read(itemProvider.notifier).build();
  });
}
  // ---------------- ADD ----------------
  // Future<void> _openAdd() async {
  //   final result = await showModalBottomSheet<Item>(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (_) => const ItemFormBottomSheet(),
  //   );

  //   if (result != null && mounted) {
  //     await ref.read(itemsProvider.notifier).addItem(
  //           title: result.title,
  //           tempImagePath: result.image,
  //           price: result.price,
  //           stock: result.stock,
  //           isMarket: result.isMarket,
  //         );
  //   }
  // }
  Future<void> _openAdd() async {
    final result = await openItemFormBottomSheet(context);

    if (result != null && mounted) {
      await ref.read(itemProvider.notifier).createItem(
            name: result.title,
            image: result.image,
            price: result.price,
            quantity: result.stock,
          );
    }
  }

  // ---------------- EDIT ----------------
  Future<void> _openEdit(Item item) async {
    final result = await openItemFormBottomSheet(context, item: item);

    if (result != null && mounted) {
      await ref.read(itemProvider.notifier).updateItem(
            id: item.id,
            name: result.title,
            image: result.image,
            price: result.price,
            quantity: result.stock,
          );
    }
  }

  // Future<void> _openEdit(Item item) async {
  //   final result = await showModalBottomSheet<Item>(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (_) => ItemFormBottomSheet(item: item),
  //   );

  //   if (result != null && mounted) {
  //     await ref.read(itemsProvider.notifier).updateItem(
  //           id: item.id,
  //           title: result.title,
  //           imagePath: result.image,
  //           price: result.price,
  //           stock: result.stock,
  //           isMarket: result.isMarket,
  //         );
  //   }
  // }

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
      await ref.read(itemProvider.notifier).deleteItem(item.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(itemProvider);
    final isAdmin = ref.watch(authProvider).isAdmin;

    return Scaffold(
      backgroundColor: const Color(0xFF0e0e10),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0e0e10),
        elevation: 0,
        title: const Text("Store"),
        actions: [
          Consumer(
            builder: (context, ref, _) {
              final isAdmin = ref.watch(authProvider).isAdmin;

              return IconButton(
                icon: Icon(isAdmin ? Icons.logout : Icons.login),
                onPressed: () {
                  if (isAdmin) {
                    ref.read(authProvider.notifier).logout();
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginScreen(),
                      ),
                    );
                  }
                },
              );
            },
          )

          //       IconButton(onPressed: (){}, icon: Icon(Icons.login)),
          //     IconButton(
          // onPressed: () {
          //   // clear session
          //   Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(builder: (_) => LoginScreen()),
          //   );
          // },
          // icon: Icon(Icons.logout),
          //)
        ],
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

                    return isAdmin
                        ? ItemCard(
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
                          )
                        : ItemTile(
                            item: item,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ItemDetailScreen(item: item),
                                ),
                              );
                            },
                          );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton.extended(
              onPressed: _openAdd,
              backgroundColor: const Color(0xFF1D9E75),
              icon: const Icon(Icons.add),
              label: const Text("Add item"),
            )
          : null,
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _openAdd,
      //   backgroundColor: const Color(0xFF1D9E75),
      //   icon: const Icon(Icons.add),
      //   label: const Text("Add item"),
      // ),
    );
  }
}
