import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inventory/models/apiitem.dart';

class ItemCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final bool isOutOfStock = (item.stock ?? 0) <= 0;
    final bool isLowStock = (item.stock ?? 0) > 0 && (item.stock ?? 0) <= 5;

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
      splashColor: Colors.white10,
    shape: RoundedRectangleBorder(
    side: BorderSide(color: isOutOfStock ? const Color.fromARGB(255, 12, 10, 10) : const Color.fromARGB(255, 28, 29, 28), width: 1),
    borderRadius: BorderRadius.circular(8),
  ),
      onTap: onTap,
      leading: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
        color: const Color(0xFF1a1a1c),
        borderRadius: BorderRadius.circular(10),
      ),
        child: item.image != null
            ? Image.file(
                File(item.image!),
                width: 52,
                height: 52,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image_outlined, color: Colors.grey),
              )
            : const Icon(Icons.image_not_supported),
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
        (item.stock != null)?
        Text(
        'QTY: ${item.stock} ',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: stockColor,
        ),
      ):
      Text(
         stockLabel,
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
            style: IconButton.styleFrom(
          // backgroundColor: Theme.of(context).colorScheme.primary, //
          // The "inner" circle color
          
           shape: const CircleBorder( side: BorderSide(strokeAlign:BorderSide.strokeAlignInside, color: Colors.white)), // Forces perfect roundness
           padding: const EdgeInsets.all(8), // Adjusts size of the inner circle
           ),
            icon: const Icon(Icons.edit_rounded, color: Colors.white),
            onPressed: () => onEdit(),
          ),
          IconButton(
            style: IconButton.styleFrom(
              shape: const CircleBorder( side: BorderSide(strokeAlign:BorderSide.strokeAlignInside, color: Color(0xFFf87171))), // Forces perfect roundness
           padding: const EdgeInsets.all(8),
            ),
            icon: const Icon(Icons.delete_rounded, color: Color(0xFFf87171)),
            onPressed: () => onDelete(),
          ),
        ],
      ),
    );
  }

}
