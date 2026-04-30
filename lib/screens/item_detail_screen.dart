import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inventory/models/apiitem.dart';

class ItemDetailScreen extends StatelessWidget {
  final Item item;

  const ItemDetailScreen({super.key, required this.item});

  String get _stockStatus {
    if (item.stock == 0) return 'Out of stock';
    if ((item.stock ?? 0) <= 5) return 'Low stock';
    return 'In stock';
  }

  Color _stockColor(BuildContext context) {
    if (item.stock == 0) return const Color(0xFFE24B4A);
   if ((item.stock ?? 0) <= 5) return const Color(0xFFEF9F27);
    return const Color(0xFF1D9E75);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item details'),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: item.image != null
    ?Image.file(
          File(item.image!),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image, size: 60, color: Colors.grey),
                ),
              ): const Icon(Icons.image_not_supported, size: 80),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        '₹${item.price.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: _stockColor(context).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _stockStatus,
                          style: TextStyle(
                            color: _stockColor(context),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _InfoRow(label: 'Stock', value: '${item.stock} units'),
                  const Divider(height: 24),
                  // _InfoRow(
                  //   label: 'Total value',
                  //   value:
                  //       '₹${(item.price * item.stock).toStringAsFixed(0)}',
                  // ),
                  // const Divider(height: 24),
                  // _InfoRow(label: 'Item ID', value: '#${item.id}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500)),
        const Spacer(),
        Text(value,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
