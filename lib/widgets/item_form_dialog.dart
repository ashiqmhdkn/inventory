import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_inventory/models/apiitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ItemFormBottomSheet extends ConsumerStatefulWidget {
  final Item? item;

  ItemFormBottomSheet({
    super.key,
    this.item,
  });

  @override
  ConsumerState<ItemFormBottomSheet> createState() =>
      _ItemFormBottomSheetState();
}

class _ItemFormBottomSheetState extends ConsumerState<ItemFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _stockCtrl;

  String itemImage = "";

  bool get _isEdit => widget.item != null;

  @override
  void initState() {
    super.initState();

    final item = widget.item;

    _titleCtrl = TextEditingController(
      text: item?.title ?? '',
    );

    _priceCtrl = TextEditingController(
      text: item != null ? item.price.toStringAsFixed(0) : '',
    );

    _stockCtrl = TextEditingController(
      text: item?.stock?.toString() ?? '',
    );

    itemImage = item?.image ?? "";
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _priceCtrl.dispose();
    _stockCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        itemImage = result.files.single.path!;
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.pop(
      context,
      Item(
        id: "",
        price: double.parse(_priceCtrl.text.trim()),
        title: _titleCtrl.text.trim(),
        image: itemImage,
        stock: _stockCtrl.text.trim().isEmpty
            ? null
            : int.parse(_stockCtrl.text.trim()),
      ),
    );

    // Navigator.pop(context, {
    //   Item(
    //     id: "",
    //     isMarket: true,
    //     price: double.parse(_priceCtrl.text.trim()),
    //     title: _titleCtrl.text.trim(),
    //     image: itemImage,
    //     mrpPrice: mrpText.isEmpty ? null : double.parse(mrpText),
    //     stock: _stockCtrl.text.trim().isEmpty
    //         ? null
    //         : int.parse(_stockCtrl.text.trim()),
    //   )
    // 'title': _titleCtrl.text.trim(),
    // 'image': itemImage,
    // 'price': double.parse(_priceCtrl.text.trim()),
    // 'mrpPrice': mrpText.isEmpty ? null : double.parse(mrpText),
    // 'stock': _stockCtrl.text.trim().isEmpty
    //     ? null
    //     : int.parse(_stockCtrl.text.trim()),
    // 'isMarket': true,
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: bottomInset,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _isEdit ? "Edit Item" : "Add Item",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(
                    labelText: "Item Name",
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? "Required" : null,
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: TextFormField(
                    controller: _priceCtrl,
                    decoration: const InputDecoration(
                      labelText: "Price",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                        v == null || v.isEmpty ? "Required" : null,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _stockCtrl,
                  decoration: const InputDecoration(
                    labelText: "Stock (Optional)",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: itemImage.isEmpty
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo_outlined, size: 32),
                              SizedBox(height: 8),
                              Text("Select Image (Optional)"),
                            ],
                          )
                        : Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  File(itemImage),
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: CircleAvatar(
                                  backgroundColor: Colors.black54,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        itemImage = "";
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: Text(_isEdit ? "Save Changes" : "Add Item"),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
