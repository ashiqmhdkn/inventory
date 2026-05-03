import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inventory/models/apiitem.dart';

class ItemTile extends StatelessWidget {
  final Item item;
  final VoidCallback onTap;

  const ItemTile({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
  
    return Container(    
        margin: const EdgeInsets.only(top:2 ,bottom: 4),
    padding: const EdgeInsets.all(6),
       decoration: BoxDecoration(
     color: const Color.fromARGB(255, 5, 5, 10), // Background color is required for shadows to show
    borderRadius: BorderRadius.circular(8),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.2),
        spreadRadius: 1,
        blurRadius: 1, // Changes position of shadow
      ),
    ],
  ),
      child: ListTile(
        splashColor: Colors.white10,
        onTap: onTap,
        title: Text(
          item.title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
       trailing: Text(
          '₹${item.price.toStringAsFixed(0)}',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );

    // return GestureDetector(
      // onTap: onTap,
      // child: Container(
      //   margin: const EdgeInsets.only(bottom: 8),
      //   padding: const EdgeInsets.all(14),
      //   decoration: BoxDecoration(
      //     color: const Color(0xFF161618),
      //     borderRadius: BorderRadius.circular(14),
      //     border: Border.all(color: const Color(0xFF222224)),
      //   ),
      //   child: Row(
      //     children: [
            // Image
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(10),
            //   child: (item.image != null && item.image!.isNotEmpty)
            //       ? Image.file(
            //           File(item.image!),
            //           width: 52,
            //           height: 52,
            //           fit: BoxFit.cover,
            //           errorBuilder: (_, __, ___) => _PlaceholderBox(),
            //         )
            //       : _PlaceholderBox(),
            // ),

            // const SizedBox(width: 14),

            // Info
            // Expanded(
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         item.title,
            //         maxLines: 1,
            //         overflow: TextOverflow.ellipsis,
            //         style: const TextStyle(
            //           color: Color(0xFFf0f0f0),
            //           fontSize: 14,
            //           fontWeight: FontWeight.w500,
            //         ),
            //       ),
            //       const SizedBox(height: 4),
            //       Text(
            //         'Stock: ${item.stock ?? 0}',
            //         style:
            //             const TextStyle(color: Color(0xFF555555), fontSize: 11),
            //       ),
            //       const SizedBox(height: 2),
            //       Text(
            //         (item.stock ?? 0) > 0 ? 'In stock' : 'Out of stock',
            //         style: TextStyle(
            //           color: (item.stock ?? 0) > 0
            //               ? const Color(0xFF444444)
            //               : const Color(0xFFf87171),
            //           fontSize: 10,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            // Price
    //         Text(
    //           '₹${mrp.toStringAsFixed(0)}',
    //           style: const TextStyle(
    //             color: Color(0xFFf0f0f0),
    //             fontSize: 13,
    //             fontWeight: FontWeight.w600,
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}

// class _PlaceholderBox extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 52,
//       height: 52,
//       decoration: BoxDecoration(
//         color: const Color(0xFF1a1a1c),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: const Icon(
//         Icons.image_outlined,
//         size: 22,
//         color: Color(0xFF333333),
//       ),
//     );
//   }
// }
