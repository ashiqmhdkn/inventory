import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inventory/models/item.dart';

class ItemTile extends StatelessWidget {
  final Item item;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ItemTile({
    super.key,
    required this.item,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOutOfStock = (item.stock ?? 0) <= 0;
    final bool isLowStock =
    (item.stock ?? 0) > 0 &&
    (item.stock ?? 0) <= 5;

    String stockLabel = isOutOfStock
        ? 'Out of stock'
        : isLowStock
            ? 'Low stock'
            : 'In stock';

    Color stockColor = isOutOfStock
        ? const Color(0xFFf87171)
        : isLowStock
            ? const Color(0xFFfbbf24)
            : const Color(0xFF34d399);

    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        child: item.image != null
    ?   Image.file(
          File(item.image!),
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.broken_image, color: Colors.grey),
        ) : const Icon(Icons.image_not_supported),
      ),
      title: Text(
        item.title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Color(0xFFe8e8e8),
        ),
      ),
      subtitle: 
    
          Text(
            'QTY: ${item.stock} \t•\t $stockLabel',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: stockColor,
            ),
          ),
        
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
            Text(
            'price:${item.price.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isOutOfStock ? Colors.grey : Colors.white,
            ),
          ),
    
          IconButton(
            icon: const Icon(Icons.edit_rounded, color: Colors.white),
            onPressed: onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete_rounded, color: Color(0xFFf87171)),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1e1e21),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Remove item?', style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to delete ${item.title}?',
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
              onDelete();
            },
            child: const Text('Delete',
                style: TextStyle(color: Color(0xFFf87171))),
          ),
        ],
      ),
    );
  }
}
