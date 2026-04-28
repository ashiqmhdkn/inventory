import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/item.dart';
import '../providers/item_provider.dart';
import 'item_detail_screen.dart';
import 'dart:io';
class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String _sortBy = 'name'; // 'name' | 'price_asc' | 'price_desc'

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Item> _applySort(List<Item> items) {
    final sorted = [...items];
    switch (_sortBy) {
      case 'price_asc':
        sorted.sort((a, b) => (a.mrpPrice ?? 0).compareTo(b.mrpPrice ?? 0));
      case 'price_desc':
        sorted.sort((a, b) => (b.mrpPrice ?? 0).compareTo(a.mrpPrice ?? 0));
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
      body: Consumer<ItemProvider>(
        builder: (context, provider, _) {
          // Only items with mrpPrice set
          final marketItems = provider.items
              .where((it) => it.mrpPrice != null)
              .toList();

          final filtered = _query.isEmpty
              ? marketItems
              : marketItems
                  .where((it) =>
                      it.title.toLowerCase().contains(_query.toLowerCase()))
                  .toList();

          final sorted = _applySort(filtered);

          return CustomScrollView(
            slivers: [
              // Search bar
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
                              builder: (_) => ItemDetailScreen(item: item),
                            ),
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
    final mrp = item.mrpPrice!;


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
      : _PlaceholderBox(),
),
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

                  Text(
                        'Price: ${mrp!.toStringAsFixed(0)}',
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