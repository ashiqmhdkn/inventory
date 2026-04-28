import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../models/item.dart';

class ItemProvider extends ChangeNotifier {
  static const _boxName = 'items';

  late Box<Item> _box;

  List<Item> get items =>
      _box.values.toList().reversed.toList();

  int get totalItems => _box.length;

  int get inStockCount =>
      _box.values.where((i) => (i.stock ?? 0) > 0).length;

  int get lowStockCount => _box.values
      .where((i) => (i.stock ?? 0) > 0 && (i.stock ?? 0) <= 5)
      .length;

  double get totalValue => _box.values.fold(
        0.0,
        (sum, i) => sum + (i.price * (i.stock ?? 0)),
      );


  Future<void> init() async {
    _box = await Hive.openBox<Item>(_boxName);
  }
Future<void> removeTempImage(String path) async {
  await _deleteImageFile(path);
}
  Future<void> addItem({
    required String title,
    String? tempImagePath,
    required double price,
    double? mrpPrice,
    int? stock,
  }) async {
    String? savedPath;

    if (tempImagePath != null &&
        tempImagePath.isNotEmpty) {
      savedPath =
          await _saveImageLocally(tempImagePath);
    }

    final item = Item(
      id: const Uuid().v4(),
      title: title,
      image: savedPath,
      price: price,
      mrpPrice: mrpPrice,
      stock: stock,
    );

    await _box.put(item.id, item);

    notifyListeners();
  }

  Future<void> updateItem({
    required String id,
    required String title,
    String? imagePath,
    required double price,
    double? mrpPrice,
    int? stock,
  }) async {
    final existing = _box.get(id);

    if (existing == null) return;

    String? savedPath = existing.image;

    if (imagePath != null &&
        imagePath.isNotEmpty &&
        imagePath != existing.image) {
      if (existing.image != null) {
        await _deleteImageFile(existing.image!);
      }

      savedPath =
          await _saveImageLocally(imagePath);
    }

    final updated = existing.copyWith(
      title: title,
      image: savedPath,
      price: price,
      mrpPrice: mrpPrice,
      stock: stock,
    );

    await _box.put(id, updated);

    notifyListeners();
  }

  Future<void> updateStock(
    String id,
    int? stock,
  ) async {
    final item = _box.get(id);

    if (item == null) return;

    await _box.put(
      id,
      item.copyWith(stock: stock),
    );

    notifyListeners();
  }

  Future<void> deleteItem(String id) async {
    final item = _box.get(id);

    if (item == null) return;

    if (item.image != null) {
      await _deleteImageFile(item.image!);
    }

    await _box.delete(id);

    notifyListeners();
  }

  Future<String> _saveImageLocally(
    String sourcePath,
  ) async {
    final dir =
        await getApplicationDocumentsDirectory();

    final fileName =
        '${const Uuid().v4()}${_ext(sourcePath)}';

    final dest =
        File('${dir.path}/$fileName');

    await File(sourcePath).copy(dest.path);

    return dest.path;
  }

  Future<void> _deleteImageFile(
    String path,
  ) async {
    try {
      final file = File(path);

      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {}
  }

  String _ext(String path) {
    final dot = path.lastIndexOf('.');

    return dot != -1
        ? path.substring(dot)
        : '.jpg';
  }
}