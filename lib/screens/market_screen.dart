import 'package:flutter_inventory/models/apiitem.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../providers/item_provider.dart';
import 'item_detail_screen.dart';
import 'dart:io';
class MarketScreen extends ConsumerStatefulWidget {
  const MarketScreen({super.key});

  @override
  ConsumerState<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends ConsumerState<MarketScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String _sortBy = 'name'; // 'name' | 'price_asc' | 'price_desc'
  @override
void initState() {
  super.initState();
  Future.microtask(() {
    ref.read(itemProvider.notifier).build();
  });
}

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Item> _applySort(List<Item> items) {
    final sorted = [...items];
    switch (_sortBy) {
      case 'price_asc':
        sorted.sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
      case 'price_desc':
        sorted.sort((a, b) => (b.price ?? 0).compareTo(a.price ?? 0));
      default:
        sorted.sort((a, b) => a.title.compareTo(b.title));
    }
    return sorted;
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161618),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF2a2a2e),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Sort by',
              style: TextStyle(
                color: Color(0xFFf0f0f0),
                fontSize: 15,
                fontWeight: FontWeight.w600,
                fontFamily: 'Syne',
              ),
            ),
            const SizedBox(height: 12),
            _SortOption(
              label: 'Name',
              icon: Icons.sort_by_alpha_rounded,
              selected: _sortBy == 'name',
              onTap: () {
                setState(() => _sortBy = 'name');
                Navigator.pop(context);
              },
            ),
            _SortOption(
              label: 'Price: Low to High',
              icon: Icons.arrow_upward_rounded,
              selected: _sortBy == 'price_asc',
              onTap: () {
                setState(() => _sortBy = 'price_asc');
                Navigator.pop(context);
              },
            ),
            _SortOption(
              label: 'Price: High to Low',
              icon: Icons.arrow_downward_rounded,
              selected: _sortBy == 'price_desc',
              onTap: () {
                setState(() => _sortBy = 'price_desc');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
     final itemsAsync = ref.watch(itemProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0e0e10),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0e0e10),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFFf59e0b),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Market',
              style: TextStyle(
                fontFamily: 'Syne',
                fontWeight: FontWeight.w800,
                fontSize: 20,
                color: Color(0xFFf0f0f0),
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: _showSortSheet,
              child: Container(
                height: 34,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1a1a1c),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF2a2a2e)),
                ),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    const Icon(Icons.sort_rounded,
                        size: 15, color: Color(0xFF888888)),
                    const SizedBox(width: 5),
                    Text(
                      _sortBy == 'name'
                          ? 'Name'
                          : _sortBy == 'price_asc'
                              ? 'Price ↑'
                              : 'Price ↓',
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF888888)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: itemsAsync.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Error: $err")),
        data: (items) {
          if (items.isEmpty) {
            return Center(child: Text("No items"));
          }
            return ListView.builder(
          //  return Consumer<ItemProvider>(
         itemBuilder: (context, index) {
          final marketItems = items;
          final filtered = _query.isEmpty
              ? marketItems
              : marketItems.where((it) =>it.title.toLowerCase().contains(_query.toLowerCase())).toList();
          final sorted = _applySort(filtered);
          return CustomScrollView(
            slivers: [      // Search bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 4, 14, 14),
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFF161618),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF2a2a2e)),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        const Icon(Icons.search_rounded,
                            size: 18, color: Color(0xFF444444)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            style: const TextStyle(
                                fontSize: 14, color: Color(0xFFcccccc)),
                            onChanged: (v) => setState(() => _query = v),
                            decoration: const InputDecoration(
                              hintText: 'Search market items…',
                              hintStyle: TextStyle(
                                  color: Color(0xFF444444), fontSize: 14),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Stats bar
              if (sorted.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  sliver: SliverToBoxAdapter(
                    child:
                        Text(
                          _query.isEmpty
                              ? 'Listed  ·  ${sorted.length}'
                              : 'Results  ·  ${sorted.length}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF444444),
                            letterSpacing: 0.06,
                          ),

                    ),
                  ),
                ),

              // Empty state
              if (sorted.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: const Color(0xFF161618),
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: const Color(0xFF2a2a2e)),
                          ),
                          child: const Icon(Icons.storefront_outlined,
                              size: 28, color: Color(0xFF444444)),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _query.isEmpty
                              ? 'No market listings'
                              : 'No results',
                          style: const TextStyle(
                            color: Color(0xFF888888),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _query.isEmpty
                              ? 'Set an MRP price on any item to list it'
                              : 'Try a different search term',
                          style: const TextStyle(
                          color: Color(0xFF444444), fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = sorted[index];
                        return _MarketItemTile(
                          item: item,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ItemDetailScreen(item: item)),
                            ),
                        );
                      },
                      childCount: sorted.length,
                    ),
                  ),
                ),
            ],
          );
         },
      );
       }
      ),

    );
  }
}

// ─── Market Item Tile ────────────────────────────────────────────────────────

class _MarketItemTile extends StatelessWidget {
  final Item item;
  final VoidCallback onTap;

  const _MarketItemTile({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF161618),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF222224)),
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: (item.image != null && item.image!.isNotEmpty)
      ? Image.file(
          File(item.image!),
          width: 52,
          height: 52,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _PlaceholderBox(),
        )
      : _PlaceholderBox(),),
            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      color: Color(0xFFf0f0f0),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      // Cost price
                      Text(
                    'Stock: ${item.stock ?? 0}',
                    style: const TextStyle(
                        color: Color(0xFF555555), fontSize: 11),
                  ),
                  const SizedBox(width: 8),
                      Text(
                  (item.stock ?? 0) > 0 ? 'In stock' : 'Out',
                  style: TextStyle(
                    color: (item.stock ?? 0) > 0
                        ? const Color(0xFF444444)
                        : const Color(0xFFf87171),
                    fontSize: 10,
                  ),
            ),
                    ],
                  ),
                ],
              ),
            ),
//price
                  Text(
                        'Price: ${item.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: Color(0xFFf0f0f0),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a1c),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(Icons.image_outlined,
          size: 22, color: Color(0xFF333333)),
    );
  }
}

// ─── Sort Option ─────────────────────────────────────────────────────────────

class _SortOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _SortOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFf59e0b).withOpacity(0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? const Color(0xFFf59e0b).withOpacity(0.3)
                : const Color(0xFF2a2a2e),
          ),
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 16,
                color: selected
                    ? const Color(0xFFf59e0b)
                    : const Color(0xFF666666)),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: selected
                    ? const Color(0xFFf0f0f0)
                    : const Color(0xFF888888),
                fontSize: 14,
              ),
            ),
            if (selected) ...[
              const Spacer(),
              const Icon(Icons.check_rounded,
                  size: 15, color: Color(0xFFf59e0b)),
            ]
          ],
        ),
      ),
    );
  }
}


// class MarketScreen extends ConsumerStatefulWidget {
//   const MarketScreen({super.key});

//   @override
//   ConsumerState<MarketScreen> createState() => _MarketScreenState();
// }

// class _MarketScreenState extends ConsumerState<MarketScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   final String _query = '';
//   String _sortBy = 'name';

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

// // ---------------- ADD ----------------
//   Future<void> _openAdd() async {
//     final result = await openItemFormBottomSheet(context);

//     if (result != null && mounted) {
//       await ref.read(itemsProvider.notifier).addItem(
//             title: result.title,
//             tempImagePath: result.image,
//             price: result.price,
//             stock: result.stock,
//             isMarket: result.isMarket,
//           );
//     }
//   }

//   // ---------------- EDIT ----------------
//   Future<void> _openEdit(Item item) async {
//     final result = await openItemFormBottomSheet(context, item: item);

//     if (result != null && mounted) {
//       await ref.read(itemsProvider.notifier).updateItem(
//             id: item.id,
//             title: result.title,
//             imagePath: result.image,
//             price: result.price,
//             stock: result.stock,
//             isMarket: result.isMarket,
//           );
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

//   List<Item> _applySort(List<Item> items) {
//     final sorted = [...items];

//     switch (_sortBy) {
//       case 'price_asc':
//         sorted.sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
//         break;

//       case 'price_desc':
//         sorted.sort((a, b) => (b.price ?? 0).compareTo(a.price ?? 0));
//         break;

//       default:
//         sorted.sort((a, b) => a.title.compareTo(b.title));
//     }

//     return sorted;
//   }

//   void _showSortSheet() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: const Color(0xFF161618),
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (_) => Padding(
//         padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             _SortOption(
//               label: 'Name',
//               icon: Icons.sort_by_alpha_rounded,
//               selected: _sortBy == 'name',
//               onTap: () {
//                 setState(() => _sortBy = 'name');
//                 Navigator.pop(context);
//               },
//             ),
//             _SortOption(
//               label: 'Price: Low to High',
//               icon: Icons.arrow_upward_rounded,
//               selected: _sortBy == 'price_asc',
//               onTap: () {
//                 setState(() => _sortBy = 'price_asc');
//                 Navigator.pop(context);
//               },
//             ),
//             _SortOption(
//               label: 'Price: High to Low',
//               icon: Icons.arrow_downward_rounded,
//               selected: _sortBy == 'price_desc',
//               onTap: () {
//                 setState(() => _sortBy = 'price_desc');
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final itemsAsync = ref.watch(itemProvider);
//     final isAdmin = ref.watch(authProvider).isAdmin;

//     return Scaffold(
//       backgroundColor: const Color(0xFF0e0e10),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF0e0e10),
//         elevation: 0,
//         title: const Text("Market"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.sort),
//             onPressed: _showSortSheet,
//           ),
//         ],
//       ),
//       body: itemsAsync.when(
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (e, _) => Center(child: Text("Error: $e")),
//         data: (allItems) {
//           // Only market items
//           final marketItems =
//               allItems.where((it) => it.price != null).toList();

//           final filtered = _query.isEmpty
//               ? marketItems
//               : marketItems
//                   .where((it) =>
//                       it.title.toLowerCase().contains(_query.toLowerCase()))
//                   .toList();

//           final sorted = _applySort(filtered);

//           if (sorted.isEmpty) {
//             return const Center(child: Text("No market items"));
//           }

//           return ListView.builder(
//             padding: const EdgeInsets.all(12),
//             itemCount: sorted.length,
//             itemBuilder: (context, index) {
//               final item = sorted[index];

//               return isAdmin
//                   ? ItemCard(
//                       item: item,
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => ItemDetailScreen(item: item),
//                           ),
//                         );
//                       },
//                       onEdit: () => _openEdit(item),
//                       onDelete: () => _confirmDelete(item),
//                     )
//                   : ItemTile(
//                       item: item,
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => ItemDetailScreen(item: item),
//                           ),
//                         );
//                       },
//                     );
//             },
//           );
//         },
//       ),
//       floatingActionButton: isAdmin
//           ? FloatingActionButton.extended(
//               onPressed: _openAdd,
//               backgroundColor: const Color(0xFF1D9E75),
//               icon: const Icon(Icons.add),
//               label: const Text("Add item"),
//             )
//           : null,
//     );
//   }
// }

