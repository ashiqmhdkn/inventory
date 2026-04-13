import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inventory/models/item.dart';

enum StockStatus { inStock, lowStock, outOfStock }

class ItemCard extends StatefulWidget {
  final Item item;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ItemCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  bool _hovered = false;

  StockStatus get _stockStatus {
    if (widget.item.stock <= 0) return StockStatus.outOfStock;
    if (widget.item.stock <= 5) return StockStatus.lowStock;
    return StockStatus.inStock;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _hovered ? -4 : 0, 0),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF161618),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _hovered
                    ? const Color(0xFF333333)
                    : const Color(0xFF222222),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // shrink-wrap the whole card
              children: [
                _ImageSection(
                  item: widget.item,
                  stockStatus: _stockStatus,
                  showActions: _hovered,
                  onEdit: widget.onEdit,
                  onDelete: () => _confirmDelete(context),
                ),
                _ContentSection(
                  item: widget.item,
                  stockStatus: _stockStatus,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1e1e21),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Remove item?',
            style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to delete ${widget.item.title}?',
          style: const TextStyle(color: Color(0xFF888888)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: Color(0xFF555555))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onDelete();
            },
            child: const Text('Delete',
                style: TextStyle(color: Color(0xFFf87171))),
          ),
        ],
      ),
    );
  }
}

// ─── Image Section ─────────────────────────────────────────────────────────

class _ImageSection extends StatelessWidget {
  final Item item;
  final StockStatus stockStatus;
  final bool showActions;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ImageSection({
    required this.item,
    required this.stockStatus,
    required this.showActions,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isOutOfStock = stockStatus == StockStatus.outOfStock;

    // Fixed height — NOT Expanded — so content below always fits
    return SizedBox(
      height: 150,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ColorFiltered(
            colorFilter: isOutOfStock
                ? const ColorFilter.matrix([
                    0.45, 0.45, 0.45, 0, 0,
                    0.45, 0.45, 0.45, 0, 0,
                    0.45, 0.45, 0.45, 0, 0,
                    0,    0,    0,    1, 0,
                  ])
                : const ColorFilter.mode(
                    Colors.transparent, BlendMode.multiply),
            child: Image.file(
  File(item.image),
  fit: BoxFit.cover,
  errorBuilder: (_, __, ___) =>
      const Icon(Icons.broken_image, color: Colors.grey),
)
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x80000000),
                  Color(0x00000000),
                  Color(0x99000000),
                ],
                stops: [0.0, 0.4, 1.0],
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity:  1.0 ,
              child: Row(
                children: [
                  _ActionButton(
                    icon: Icons.edit_rounded,
                    iconColor: Colors.white,
                    bg: Colors.white24,
                    onTap: onEdit,
                  ),
                  const SizedBox(width: 5),
                  _ActionButton(
                    icon: Icons.delete_rounded,
                    iconColor: const Color(0xFFf87171),
                    bg: const Color(0x44EF4444),
                    onTap: onDelete,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            child: _StockBadge(status: stockStatus),
          ),
        ],
      ),
    );
  }
}

// ─── Content Section ────────────────────────────────────────────────────────

class _ContentSection extends StatelessWidget {
  final Item item;
  final StockStatus stockStatus;

  const _ContentSection({
    required this.item,
    required this.stockStatus,
  });

  @override
  Widget build(BuildContext context) {
    final isOutOfStock = stockStatus == StockStatus.outOfStock;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // never expand beyond children
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFe8e8e8),
                    letterSpacing: -0.1,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '\$${item.price.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: isOutOfStock
                      ? const Color(0xFF555555)
                      : Colors.white,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Divider(height: 1, thickness: 0.5, color: Color(0xFF222222)),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'QTY',
                style: TextStyle(
                  fontSize: 9,
                  color: Color(0xFF444444),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.08,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                item.stock.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isOutOfStock
                      ? const Color(0xFFf87171)
                      : const Color(0xFFe8e8e8),
                ),
              ),
              
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Stock Badge ─────────────────────────────────────────────────────────────

class _StockBadge extends StatelessWidget {
  final StockStatus status;
  const _StockBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color, bg, border) = switch (status) {
      StockStatus.inStock => (
          'In stock',
          const Color(0xFF34d399),
          const Color(0xFF10B981),
          const Color(0xFF34d399),
        ),
      StockStatus.lowStock => (
          'Low stock',
          const Color(0xFFfbbf24),
          const Color(0xFFF59E0B),
          const Color(0xFFfbbf24),
        ),
      StockStatus.outOfStock => (
          'Out of stock',
          const Color(0xFFf87171),
          const Color(0xFFEF4444),
          const Color(0xFFf87171),
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style:
                TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: color),
          ),
        ],
      ),
    );
  }
}

// ─── Action Button ────────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bg;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.iconColor,
    required this.bg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(shape: BoxShape.circle, color: bg),
        child: Icon(icon, size: 13, color: iconColor),
      ),
    );
  }
}