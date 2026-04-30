import 'package:flutter/material.dart';
import '../models/item.dart';
import '../widgets/item_form_dialog.dart';

Future<Item?> openItemFormBottomSheet(BuildContext context, {Item? item}) {
  return showModalBottomSheet<Item>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => ItemFormBottomSheet(item: item),
  );
}
