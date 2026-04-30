// // // // // // // import 'dart:io';
// // // // // // // import 'package:flutter/foundation.dart';
// // // // // // // import 'package:hive_flutter/hive_flutter.dart';
// // // // // // // import 'package:path_provider/path_provider.dart';
// // // // // // // import 'package:uuid/uuid.dart';
// // // // // // // import '../models/item.dart';

// // // // // // // class ItemProvider extends ChangeNotifier {
// // // // // // //   static const _boxName = 'items';

// // // // // // //   late Box<Item> _box;

// // // // // // //   List<Item> get items =>
// // // // // // //       _box.values.toList().reversed.toList();

// // // // // // //   int get totalItems => _box.length;

// // // // // // //   int get inStockCount =>
// // // // // // //       _box.values.where((i) => (i.stock ?? 0) > 0).length;

// // // // // // //   int get lowStockCount => _box.values
// // // // // // //       .where((i) => (i.stock ?? 0) > 0 && (i.stock ?? 0) <= 5)
// // // // // // //       .length;

// // // // // // //   double get totalValue => _box.values.fold(
// // // // // // //         0.0,
// // // // // // //         (sum, i) => sum + (i.price * (i.stock ?? 0)),
// // // // // // //       );

// // // // // // //   Future<void> init() async {
// // // // // // //     _box = await Hive.openBox<Item>(_boxName);
// // // // // // //   }
// // // // // // // Future<void> removeTempImage(String path) async {
// // // // // // //   await _deleteImageFile(path);
// // // // // // // }
// // // // // // //   // Future<void> addItem({
// // // // // // //   //   required String title,
// // // // // // //   //   String? tempImagePath,
// // // // // // //   //   required double price,
// // // // // // //   //   double? mrpPrice,
// // // // // // //   //   int? stock, required bool isMarket,
// // // // // // //   // }) async {
// // // // // // //   //   String? savedPath;

// // // // // // //   //   if (tempImagePath != null &&
// // // // // // //   //       tempImagePath.isNotEmpty) {
// // // // // // //   //     savedPath =
// // // // // // //   //         await _saveImageLocally(tempImagePath);
// // // // // // //   //   }

// // // // // // //   //   final item = Item(
// // // // // // //   //     id: const Uuid().v4(),
// // // // // // //   //     title: title,
// // // // // // //   //     image: savedPath,
// // // // // // //   //     price: price,
// // // // // // //   //     mrpPrice: mrpPrice,
// // // // // // //   //     stock: stock,
// // // // // // //   //   );

// // // // // // //   //   await _box.put(item.id, item);

// // // // // // //   //   notifyListeners();
// // // // // // //   // }

// // // // // // //   // Future<void> updateItem({
// // // // // // //   //   required String id,
// // // // // // //   //   required String title,
// // // // // // //   //   String? imagePath,
// // // // // // //   //   required double price,
// // // // // // //   //   double? mrpPrice,
// // // // // // //   //   int? stock, required bool isMarket,
// // // // // // //   // }) async {
// // // // // // //   //   final existing = _box.get(id);

// // // // // // //   //   if (existing == null) return;

// // // // // // //   //   String? savedPath = existing.image;

// // // // // // //   //   if (imagePath != null &&
// // // // // // //   //       imagePath.isNotEmpty &&
// // // // // // //   //       imagePath != existing.image) {
// // // // // // //   //     if (existing.image != null) {
// // // // // // //   //       await _deleteImageFile(existing.image!);
// // // // // // //   //     }

// // // // // // //   //     savedPath =
// // // // // // //   //         await _saveImageLocally(imagePath);
// // // // // // //   //   }

// // // // // // //   //   final updated = existing.copyWith(
// // // // // // //   //     title: title,
// // // // // // //   //     image: savedPath,
// // // // // // //   //     price: price,
// // // // // // //   //     mrpPrice: mrpPrice,
// // // // // // //   //     stock: stock,
// // // // // // //   //   );

// // // // // // //   //   await _box.put(id, updated);

// // // // // // //   //   notifyListeners();
// // // // // // //   // }

// // // // // // //   // Future<void> updateStock(
// // // // // // //   //   String id,
// // // // // // //   //   int? stock,
// // // // // // //   // ) async {
// // // // // // //   //   final item = _box.get(id);

// // // // // // //   //   if (item == null) return;

// // // // // // //   //   await _box.put(
// // // // // // //   //     id,
// // // // // // //   //     item.copyWith(stock: stock),
// // // // // // //   //   );

// // // // // // //   //   notifyListeners();
// // // // // // //   // }

// // // // // // //   // Future<void> deleteItem(String id) async {
// // // // // // //   //   final item = _box.get(id);

// // // // // // //   //   if (item == null) return;

// // // // // // //   //   if (item.image != null) {
// // // // // // //   //     await _deleteImageFile(item.image!);
// // // // // // //   //   }

// // // // // // //   //   await _box.delete(id);

// // // // // // //   //   notifyListeners();
// // // // // // //   // }

// // // // // // // Future<bool> createItem({
// // // // // // //     required String name,
// // // // // // //     required double price,
// // // // // // //     required int quantity,
// // // // // // //     required File imageFile,
// // // // // // //   }) async {
// // // // // // //     var request = http.MultipartRequest(
// // // // // // //       'POST',
// // // // // // //       Uri.parse('$baseUrl/items'),
// // // // // // //     );

// // // // // // //     request.fields['name'] = name;
// // // // // // //     request.fields['price'] = price.toString();
// // // // // // //     request.fields['quantity'] = quantity.toString();

// // // // // // //     request.files.add(
// // // // // // //       await http.MultipartFile.fromPath('image', imageFile.path),
// // // // // // //     );

// // // // // // //     var response = await request.send();
// // // // // // //     return response.statusCode == 200;
// // // // // // //   }

// // // // // // //   // ---------------- GET ITEMS ----------------
// // // // // // //   Future<List<Item>> getItems() async {
// // // // // // //     final res = await http.get(Uri.parse('$baseUrl/items'));

// // // // // // //     if (res.statusCode == 200) {
// // // // // // //       final data = jsonDecode(res.body);
// // // // // // //       return (data as List)
// // // // // // //           .map((e) => Item.fromJson(e))
// // // // // // //           .toList();
// // // // // // //     } else {
// // // // // // //       throw Exception("Failed to load items");
// // // // // // //     }
// // // // // // //   }

// // // // // // //   // ---------------- UPDATE ITEM ----------------
// // // // // // //   Future<bool> updateItem({
// // // // // // //     required String id,
// // // // // // //     required String name,
// // // // // // //     required double price,
// // // // // // //     required int quantity,
// // // // // // //     String? image, // optional
// // // // // // //   }) async {
// // // // // // //     final res = await http.put(
// // // // // // //       Uri.parse('$baseUrl/items/$id'),
// // // // // // //       headers: {'Content-Type': 'application/json'},
// // // // // // //       body: jsonEncode({
// // // // // // //         "name": name,
// // // // // // //         "price": price,
// // // // // // //         "quantity": quantity,
// // // // // // //         "image": image ?? "",
// // // // // // //       }),
// // // // // // //     );

// // // // // // //     return res.statusCode == 200;
// // // // // // //   }

// // // // // // //   // ---------------- DELETE ITEM ----------------
// // // // // // //   Future<bool> deleteItem(String id) async {
// // // // // // //     final res =
// // // // // // //         await http.delete(Uri.parse('$baseUrl/items/$id'));

// // // // // // //     return res.statusCode == 200;
// // // // // // //   }

// // // // // // //  // ---------------- CREATE ----------------
// // // // // // //   Future<bool> createItem({
// // // // // // //     required String name,
// // // // // // //     required double price,
// // // // // // //     required int quantity,
// // // // // // //     required String image,
// // // // // // //   }) async {
// // // // // // //     try {
// // // // // // //       final success = await itemsPost(
// // // // // // //         name: name,
// // // // // // //         price: price,
// // // // // // //         quantity: quantity,
// // // // // // //         image: image,
// // // // // // //       );

// // // // // // //       if (success) {
// // // // // // //         state = await AsyncValue.guard(() => itemsGet());
// // // // // // //       }

// // // // // // //       return success;
// // // // // // //     } catch (e) {
// // // // // // //       return false;
// // // // // // //     }
// // // // // // //   }

// // // // // // //   // ---------------- UPDATE ----------------
// // // // // // //   Future<bool> updateItem({
// // // // // // //     required String id,
// // // // // // //     required String name,
// // // // // // //     required double price,
// // // // // // //     required int quantity,
// // // // // // //     required String image,
// // // // // // //   }) async {
// // // // // // //     try {
// // // // // // //       final success = await itemsPut(
// // // // // // //         id: id,
// // // // // // //         name: name,
// // // // // // //         price: price,
// // // // // // //         quantity: quantity,
// // // // // // //         image: image,
// // // // // // //       );

// // // // // // //       if (success) {
// // // // // // //         state = const AsyncValue.loading();
// // // // // // //         state = await AsyncValue.guard(() => itemsGet());
// // // // // // //       }

// // // // // // //       return success;
// // // // // // //     } catch (e) {
// // // // // // //       return false;
// // // // // // //     }
// // // // // // //   }

// // // // // // //   // ---------------- DELETE ----------------
// // // // // // //   Future<bool> deleteItem(String id) async {
// // // // // // //     try {
// // // // // // //       final success = await itemsDelete(id);

// // // // // // //       if (success) {
// // // // // // //         state = const AsyncValue.loading();
// // // // // // //         state = await AsyncValue.guard(() => itemsGet());
// // // // // // //       }

// // // // // // //       return success;
// // // // // // //     } catch (e) {
// // // // // // //       return false;
// // // // // // //     }
// // // // // // //   }

// // // // // // //   // ---------------- REFRESH ----------------
// // // // // // //   Future<void> refresh() async {
// // // // // // //     state = const AsyncValue.loading();
// // // // // // //     state = await AsyncValue.guard(() => itemsGet());
// // // // // // //   }

// // // // // // //   Future<void> addItem({
// // // // // // //   required String title,
// // // // // // //   String? tempImagePath,
// // // // // // //   required double price,
// // // // // // //   double? mrpPrice,
// // // // // // //   int? stock,
// // // // // // //   required bool isMarket,
// // // // // // // }) async {
// // // // // // //   String? savedPath;

// // // // // // //   if (tempImagePath != null && tempImagePath.isNotEmpty) {
// // // // // // //     savedPath = await _saveImageLocally(tempImagePath);
// // // // // // //   }

// // // // // // //   final item = Item(
// // // // // // //     id: const Uuid().v4(),
// // // // // // //     title: title,
// // // // // // //     image: savedPath,
// // // // // // //     price: price,
// // // // // // //     mrpPrice: mrpPrice ?? price, // fallback
// // // // // // //     stock: stock,
// // // // // // //     isMarket: isMarket, // ✅ added
// // // // // // //   );

// // // // // // //   await _box.put(item.id, item);

// // // // // // //   notifyListeners();
// // // // // // // }

// // // // // // // Future<void> updateItem({
// // // // // // //   required String id,
// // // // // // //   required String title,
// // // // // // //   String? imagePath,
// // // // // // //   required double price,
// // // // // // //   double? mrpPrice,
// // // // // // //   int? stock,
// // // // // // //   required bool isMarket,
// // // // // // // }) async {
// // // // // // //   final existing = _box.get(id);
// // // // // // //   if (existing == null) return;

// // // // // // //   String? savedPath = existing.image;

// // // // // // //   if (imagePath != null &&
// // // // // // //       imagePath.isNotEmpty &&
// // // // // // //       imagePath != existing.image) {
// // // // // // //     if (existing.image != null) {
// // // // // // //       await _deleteImageFile(existing.image!);
// // // // // // //     }

// // // // // // //     savedPath = await _saveImageLocally(imagePath);
// // // // // // //   }

// // // // // // //   final updated = existing.copyWith(
// // // // // // //     title: title,
// // // // // // //     image: savedPath,
// // // // // // //     price: price,
// // // // // // //     mrpPrice: mrpPrice ?? existing.mrpPrice, // fallback
// // // // // // //     stock: stock,
// // // // // // //     isMarket: isMarket, // ✅ added
// // // // // // //   );

// // // // // // //   await _box.put(id, updated);

// // // // // // //   notifyListeners();
// // // // // // // }

// // // // // // // Future<void> updateStock(
// // // // // // //   String id,
// // // // // // //   int? stock,
// // // // // // // ) async {
// // // // // // //   final item = _box.get(id);
// // // // // // //   if (item == null) return;

// // // // // // //   await _box.put(
// // // // // // //     id,
// // // // // // //     item.copyWith(
// // // // // // //       stock: stock,
// // // // // // //       // keep existing isMarket implicitly
// // // // // // //     ),
// // // // // // //   );

// // // // // // //   notifyListeners();
// // // // // // // }

// // // // // // // Future<void> deleteItem(String id) async {
// // // // // // //   final item = _box.get(id);
// // // // // // //   if (item == null) return;

// // // // // // //   if (item.image != null) {
// // // // // // //     await _deleteImageFile(item.image!);
// // // // // // //   }

// // // // // // //   await _box.delete(id);

// // // // // // //   notifyListeners();
// // // // // // // }

// // // // // // //   Future<String> _saveImageLocally(
// // // // // // //     String sourcePath,
// // // // // // //   ) async {
// // // // // // //     final dir =
// // // // // // //         await getApplicationDocumentsDirectory();

// // // // // // //     final fileName =
// // // // // // //         '${const Uuid().v4()}${_ext(sourcePath)}';

// // // // // // //     final dest =
// // // // // // //         File('${dir.path}/$fileName');

// // // // // // //     await File(sourcePath).copy(dest.path);

// // // // // // //     return dest.path;
// // // // // // //   }

// // // // // // //   Future<void> _deleteImageFile(
// // // // // // //     String path,
// // // // // // //   ) async {
// // // // // // //     try {
// // // // // // //       final file = File(path);

// // // // // // //       if (await file.exists()) {
// // // // // // //         await file.delete();
// // // // // // //       }
// // // // // // //     } catch (_) {}
// // // // // // //   }

// // // // // // //   String _ext(String path) {
// // // // // // //     final dot = path.lastIndexOf('.');

// // // // // // //     return dot != -1
// // // // // // //         ? path.substring(dot)
// // // // // // //         : '.jpg';
// // // // // // //   }
// // // // // // // }

// // // // // // import 'dart:io';
// // // // // // import 'dart:convert';

// // // // // // import 'package:flutter/foundation.dart';
// // // // // // import 'package:hive_flutter/hive_flutter.dart';
// // // // // // import 'package:path_provider/path_provider.dart';
// // // // // // import 'package:uuid/uuid.dart';
// // // // // // import 'package:http/http.dart' as http;

// // // // // // import '../models/item.dart';

// // // // // // class ItemProvider extends ChangeNotifier {
// // // // // //   static const _boxName = 'items';
// // // // // //   static const String baseUrl = "https://your-api-url.com"; // 🔁 change this

// // // // // //   late Box<Item> _box;

// // // // // //   // ---------------- LOCAL DATA ----------------

// // // // // //   List<Item> get items =>
// // // // // //       _box.values.toList().reversed.toList();

// // // // // //   int get totalItems => _box.length;

// // // // // //   int get inStockCount =>
// // // // // //       _box.values.where((i) => (i.stock ?? 0) > 0).length;

// // // // // //   int get lowStockCount => _box.values
// // // // // //       .where((i) => (i.stock ?? 0) > 0 && (i.stock ?? 0) <= 5)
// // // // // //       .length;

// // // // // //   double get totalValue => _box.values.fold(
// // // // // //         0.0,
// // // // // //         (sum, i) => sum + (i.price * (i.stock ?? 0)),
// // // // // //       );

// // // // // //   Future<void> init() async {
// // // // // //     _box = await Hive.openBox<Item>(_boxName);
// // // // // //   }

// // // // // //   // ---------------- LOCAL CRUD ----------------

// // // // // //   Future<void> addItem({
// // // // // //     required String title,
// // // // // //     String? tempImagePath,
// // // // // //     required double price,
// // // // // //     double? mrpPrice,
// // // // // //     int? stock,
// // // // // //     required bool isMarket,
// // // // // //   }) async {
// // // // // //     String? savedPath;

// // // // // //     if (tempImagePath != null && tempImagePath.isNotEmpty) {
// // // // // //       savedPath = await _saveImageLocally(tempImagePath);
// // // // // //     }

// // // // // //     final item = Item(
// // // // // //       id: const Uuid().v4(),
// // // // // //       title: title,
// // // // // //       image: savedPath,
// // // // // //       price: price,
// // // // // //       mrpPrice: mrpPrice ?? price,
// // // // // //       stock: stock,
// // // // // //       isMarket: isMarket,
// // // // // //     );

// // // // // //     await _box.put(item.id, item);
// // // // // //     notifyListeners();
// // // // // //   }

// // // // // //   Future<void> updateItem({
// // // // // //     required String id,
// // // // // //     required String title,
// // // // // //     String? imagePath,
// // // // // //     required double price,
// // // // // //     double? mrpPrice,
// // // // // //     int? stock,
// // // // // //     required bool isMarket,
// // // // // //   }) async {
// // // // // //     final existing = _box.get(id);
// // // // // //     if (existing == null) return;

// // // // // //     String? savedPath = existing.image;

// // // // // //     if (imagePath != null &&
// // // // // //         imagePath.isNotEmpty &&
// // // // // //         imagePath != existing.image) {
// // // // // //       if (existing.image != null) {
// // // // // //         await _deleteImageFile(existing.image!);
// // // // // //       }

// // // // // //       savedPath = await _saveImageLocally(imagePath);
// // // // // //     }

// // // // // //     final updated = existing.copyWith(
// // // // // //       title: title,
// // // // // //       image: savedPath,
// // // // // //       price: price,
// // // // // //       mrpPrice: mrpPrice ?? existing.mrpPrice,
// // // // // //       stock: stock,
// // // // // //       isMarket: isMarket,
// // // // // //     );

// // // // // //     await _box.put(id, updated);
// // // // // //     notifyListeners();
// // // // // //   }

// // // // // //   Future<void> updateStock(String id, int? stock) async {
// // // // // //     final item = _box.get(id);
// // // // // //     if (item == null) return;

// // // // // //     await _box.put(
// // // // // //       id,
// // // // // //       item.copyWith(stock: stock),
// // // // // //     );

// // // // // //     notifyListeners();
// // // // // //   }

// // // // // //   Future<void> deleteItem(String id) async {
// // // // // //     final item = _box.get(id);
// // // // // //     if (item == null) return;

// // // // // //     if (item.image != null) {
// // // // // //       await _deleteImageFile(item.image!);
// // // // // //     }

// // // // // //     await _box.delete(id);
// // // // // //     notifyListeners();
// // // // // //   }

// // // // // //   // ---------------- API (OPTIONAL) ----------------

// // // // // //   Future<List<Item>> fetchItemsFromApi() async {
// // // // // //     final res = await http.get(Uri.parse('$baseUrl/items'));

// // // // // //     if (res.statusCode == 200) {
// // // // // //       final data = jsonDecode(res.body);
// // // // // //       return (data as List)
// // // // // //           .map((e) => Item.fromJson(e))
// // // // // //           .toList();
// // // // // //     } else {
// // // // // //       throw Exception("Failed to load items");
// // // // // //     }
// // // // // //   }

// // // // // //   Future<bool> createItemApi({
// // // // // //     required String name,
// // // // // //     required double price,
// // // // // //     required int quantity,
// // // // // //     required File imageFile,
// // // // // //   }) async {
// // // // // //     var request = http.MultipartRequest(
// // // // // //       'POST',
// // // // // //       Uri.parse('$baseUrl/items'),
// // // // // //     );

// // // // // //     request.fields['name'] = name;
// // // // // //     request.fields['price'] = price.toString();
// // // // // //     request.fields['quantity'] = quantity.toString();

// // // // // //     request.files.add(
// // // // // //       await http.MultipartFile.fromPath('image', imageFile.path),
// // // // // //     );

// // // // // //     var response = await request.send();
// // // // // //     return response.statusCode == 200;
// // // // // //   }

// // // // // //   Future<bool> updateItemApi({
// // // // // //     required String id,
// // // // // //     required String name,
// // // // // //     required double price,
// // // // // //     required int quantity,
// // // // // //     String? image,
// // // // // //   }) async {
// // // // // //     final res = await http.put(
// // // // // //       Uri.parse('$baseUrl/items/$id'),
// // // // // //       headers: {'Content-Type': 'application/json'},
// // // // // //       body: jsonEncode({
// // // // // //         "name": name,
// // // // // //         "price": price,
// // // // // //         "quantity": quantity,
// // // // // //         "image": image ?? "",
// // // // // //       }),
// // // // // //     );

// // // // // //     return res.statusCode == 200;
// // // // // //   }

// // // // // //   Future<bool> deleteItemApi(String id) async {
// // // // // //     final res =
// // // // // //         await http.delete(Uri.parse('$baseUrl/items/$id'));

// // // // // //     return res.statusCode == 200;
// // // // // //   }

// // // // // //   // ---------------- IMAGE HELPERS ----------------

// // // // // //   Future<String> _saveImageLocally(String sourcePath) async {
// // // // // //     final dir = await getApplicationDocumentsDirectory();

// // // // // //     final fileName =
// // // // // //         '${const Uuid().v4()}${_ext(sourcePath)}';

// // // // // //     final dest = File('${dir.path}/$fileName');

// // // // // //     await File(sourcePath).copy(dest.path);

// // // // // //     return dest.path;
// // // // // //   }

// // // // // //   Future<void> _deleteImageFile(String path) async {
// // // // // //     try {
// // // // // //       final file = File(path);

// // // // // //       if (await file.exists()) {
// // // // // //         await file.delete();
// // // // // //       }
// // // // // //     } catch (_) {}
// // // // // //   }

// // // // // //   String _ext(String path) {
// // // // // //     final dot = path.lastIndexOf('.');
// // // // // //     return dot != -1 ? path.substring(dot) : '.jpg';
// // // // // //   }

// // // // // //   Future<void> removeTempImage(String path) async {
// // // // // //     await _deleteImageFile(path);
// // // // // //   }
// // // // // // }
// // // // // import 'dart:io';
// // // // // import 'dart:convert';

// // // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // // import 'package:hive_flutter/hive_flutter.dart';
// // // // // import 'package:path_provider/path_provider.dart';
// // // // // import 'package:uuid/uuid.dart';
// // // // // import 'package:http/http.dart' as http;

// // // // // import '../models/item.dart';

// // // // // final itemsProvider = AsyncNotifierProvider<ItemsNotifier, List<Item>>(
// // // // //   ItemsNotifier.new,
// // // // // );

// // // // // class ItemsNotifier extends AsyncNotifier<List<Item>> {
// // // // //   static const _boxName = 'items';
// // // // //   late Box<Item> _box;

// // // // //   @override
// // // // //   Future<List<Item>> build() async {
// // // // //     _box = await Hive.openBox<Item>(_boxName);
// // // // //     return _getItems();
// // // // //   }

// // // // //   List<Item> _getItems() {
// // // // //     return _box.values.toList().reversed.toList();
// // // // //   }

// // // // //   // ---------------- LOCAL CRUD ----------------

// // // // //   Future<void> addItem({
// // // // //     required String title,
// // // // //     String? tempImagePath,
// // // // //     required double price,
// // // // //     double? mrpPrice,
// // // // //     int? stock,
// // // // //     required bool isMarket,
// // // // //   }) async {
// // // // //     String? savedPath;

// // // // //     if (tempImagePath != null && tempImagePath.isNotEmpty) {
// // // // //       savedPath = await _saveImageLocally(tempImagePath);
// // // // //     }

// // // // //     final item = Item(
// // // // //       id: const Uuid().v4(),
// // // // //       title: title,
// // // // //       image: savedPath,
// // // // //       price: price,
// // // // //       mrpPrice: mrpPrice ?? price,
// // // // //       stock: stock,
// // // // //       isMarket: isMarket,
// // // // //     );

// // // // //     await _box.put(item.id, item);
// // // // //     state = AsyncData(_getItems());
// // // // //   }

// // // // //   Future<void> updateItem({
// // // // //     required String id,
// // // // //     required String title,
// // // // //     String? imagePath,
// // // // //     required double price,
// // // // //     double? mrpPrice,
// // // // //     int? stock,
// // // // //     required bool isMarket,
// // // // //   }) async {
// // // // //     final existing = _box.get(id);
// // // // //     if (existing == null) return;

// // // // //     String? savedPath = existing.image;

// // // // //     if (imagePath != null &&
// // // // //         imagePath.isNotEmpty &&
// // // // //         imagePath != existing.image) {
// // // // //       if (existing.image != null) {
// // // // //         await _deleteImageFile(existing.image!);
// // // // //       }

// // // // //       savedPath = await _saveImageLocally(imagePath);
// // // // //     }

// // // // //     final updated = existing.copyWith(
// // // // //       title: title,
// // // // //       image: savedPath,
// // // // //       price: price,
// // // // //       mrpPrice: mrpPrice ?? existing.mrpPrice,
// // // // //       stock: stock,
// // // // //       isMarket: isMarket,
// // // // //     );

// // // // //     await _box.put(id, updated);
// // // // //     state = AsyncData(_getItems());
// // // // //   }

// // // // //   Future<void> deleteItem(String id) async {
// // // // //     final item = _box.get(id);
// // // // //     if (item == null) return;

// // // // //     if (item.image != null) {
// // // // //       await _deleteImageFile(item.image!);
// // // // //     }

// // // // //     await _box.delete(id);
// // // // //     state = AsyncData(_getItems());
// // // // //   }

// // // // //   // ---------------- IMAGE HELPERS ----------------

// // // // //   Future<String> _saveImageLocally(String sourcePath) async {
// // // // //     final dir = await getApplicationDocumentsDirectory();

// // // // //     final fileName = '${const Uuid().v4()}${_ext(sourcePath)}';

// // // // //     final dest = File('${dir.path}/$fileName');

// // // // //     await File(sourcePath).copy(dest.path);

// // // // //     return dest.path;
// // // // //   }

// // // // //   Future<void> _deleteImageFile(String path) async {
// // // // //     try {
// // // // //       final file = File(path);
// // // // //       if (await file.exists()) await file.delete();
// // // // //     } catch (_) {}
// // // // //   }

// // // // //   String _ext(String path) {
// // // // //     final dot = path.lastIndexOf('.');
// // // // //     return dot != -1 ? path.substring(dot) : '.jpg';
// // // // //   }
// // // // // }
// // // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // // import 'package:hive/hive.dart';

// // // // // import '../models/item.dart';
// // // // // import '../services/item_api_service.dart';
// // // // // import '../repositories/item_repository.dart';

// // // // // final hiveBoxProvider = Provider<Box<Item>>((ref) {
// // // // //   throw UnimplementedError(); // will inject from main
// // // // // });

// // // // // // final apiProvider = Provider((ref) => ItemApiService());

// // // // // // final repositoryProvider = Provider((ref) {
// // // // // //   return ItemRepository(
// // // // // //     ref.read(hiveBoxProvider),
// // // // // //     ref.read(apiProvider),
// // // // // //   );
// // // // // // });

// // // // // // final itemsProvider =
// // // // // //     AsyncNotifierProvider<ItemsNotifier, List<Item>>(ItemsNotifier.new);

// // // // // // class ItemsNotifier extends AsyncNotifier<List<Item>> {
// // // // // //   late final ItemRepository repo;

// // // // // //   @override
// // // // // //   Future<List<Item>> build() async {
// // // // // //     repo = ref.read(repositoryProvider);
// // // // // //     return repo.getItems();
// // // // // //   }

// // // // // //   // Future<void> addItem(Item item) async {
// // // // // //   //   await repo.addItem(item);
// // // // // //   //   state = AsyncValue.data(await repo.getItems());
// // // // // //   // }

// // // // // //   Future<void> addItem({
// // // // // //     required String title,
// // // // // //     String? tempImagePath,
// // // // // //     required double price,
// // // // // //     int? stock,
// // // // // //     required bool isMarket,
// // // // // //   }) async {
// // // // // //     final item = Item(
// // // // // //       id: DateTime.now().millisecondsSinceEpoch.toString(),
// // // // // //       title: title,
// // // // // //       image: tempImagePath,
// // // // // //       price: price,
// // // // // //       mrpPrice: price,
// // // // // //       stock: stock,
// // // // // //       isMarket: isMarket,
// // // // // //     );
// // // // // //     print(isMarket);
// // // // // //     await repo.addItem(item);
// // // // // //     print(item.price);
// // // // // //     state = AsyncValue.data(await repo.getItems());
// // // // // //   }

// // // // // //   // Future<void> updateItem(Item item) async {
// // // // // //   //   await repo.updateItem(item);
// // // // // //   //   state = AsyncValue.data(await repo.getItems());
// // // // // //   // }

// // // // // //   Future<void> updateItem({
// // // // // //     required String id,
// // // // // //     required String title,
// // // // // //     String? imagePath,
// // // // // //     required double price,
// // // // // //     int? stock,
// // // // // //     required bool isMarket,
// // // // // //   }) async {
// // // // // //     final item = Item(
// // // // // //       id: id,
// // // // // //       title: title,
// // // // // //       image: imagePath,
// // // // // //       price: price,
// // // // // //       mrpPrice: price,
// // // // // //       stock: stock,
// // // // // //       isMarket: isMarket,
// // // // // //     );

// // // // // //     await repo.updateItem(item);

// // // // // //     state = AsyncValue.data(await repo.getItems());
// // // // // //   }

// // // // // //   Future<void> deleteItem(String id) async {
// // // // // //     await repo.deleteItem(id);
// // // // // //     state = AsyncValue.data(await repo.getItems());
// // // // // //   }
// // // // // final apiProvider = Provider<ItemApiService>((ref) {
// // // // //   return ItemApiService();
// // // // // });

// // // // // final repositoryProvider = Provider<ItemRepository>((ref) {
// // // // //   return ItemRepository(
// // // // //     ref.read(hiveBoxProvider),
// // // // //     ref.read(apiProvider),
// // // // //   );
// // // // // });

// // // // // final itemsProvider =
// // // // //     AsyncNotifierProvider<ItemsNotifier, List<Item>>(ItemsNotifier.new);

// // // // // class ItemsNotifier extends AsyncNotifier<List<Item>> {
// // // // //   late final ItemRepository repo;

// // // // //   @override
// // // // //   Future<List<Item>> build() async {
// // // // //     repo = ref.read(repositoryProvider);
// // // // //     return await repo.getItems(); // ✅ correct
// // // // //   }

// // // // //   Future<void> addItem({
// // // // //     required String title,
// // // // //     String? tempImagePath,
// // // // //     required double price,
// // // // //     int? stock,
// // // // //     required bool isMarket,
// // // // //   }) async {
// // // // //     final item = Item(
// // // // //       id: DateTime.now().millisecondsSinceEpoch.toString(),
// // // // //       title: title,
// // // // //       image: tempImagePath,
// // // // //       price: price,
// // // // //       mrpPrice: price,
// // // // //       stock: stock,
// // // // //       isMarket: isMarket,
// // // // //     );

// // // // //     await repo.addItem(item);

// // // // //     state = AsyncValue.data(await repo.getItems());
// // // // //   }

// // // // //   Future<void> updateItem({
// // // // //     required String id,
// // // // //     required String title,
// // // // //     String? imagePath,
// // // // //     required double price,
// // // // //     int? stock,
// // // // //     required bool isMarket,
// // // // //   }) async {
// // // // //     final item = Item(
// // // // //       id: id,
// // // // //       title: title,
// // // // //       image: imagePath,
// // // // //       price: price,
// // // // //       mrpPrice: price,
// // // // //       stock: stock,
// // // // //       isMarket: isMarket,
// // // // //     );

// // // // //     await repo.updateItem(item);

// // // // //     state = AsyncValue.data(await repo.getItems());
// // // // //   }

// // // // //   Future<void> deleteItem(String id) async {
// // // // //     await repo.deleteItem(id);
// // // // //     state = AsyncValue.data(await repo.getItems());
// // // // //   }
// // // // // }
// // // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // // import 'package:hive/hive.dart';
// // // // import 'package:http/http.dart' as http;

// // // // import '../models/item.dart';
// // // // import '../services/item_api_service.dart';
// // // // import '../repositories/item_repository.dart';

// // // // // ---------------- HIVE ----------------
// // // // final hiveBoxProvider = Provider<Box<Item>>((ref) {
// // // //   throw UnimplementedError(); // override in main
// // // // });

// // // // // ---------------- API ----------------
// // // // final apiProvider = Provider<ItemApiService>((ref) {
// // // //   return ItemApiService();
// // // // });

// // // // // ---------------- REPOSITORY ----------------
// // // // final repositoryProvider = Provider<ItemRepository>((ref) {
// // // //   return ItemRepository(
// // // //     ref.read(hiveBoxProvider),
// // // //     ref.read(apiProvider),
// // // //   );
// // // // });

// // // // // ---------------- STATE ----------------
// // // // final itemsProvider =
// // // //     AsyncNotifierProvider<ItemsNotifier, List<Item>>(ItemsNotifier.new);

// // // // // ---------------- NOTIFIER ----------------
// // // // class ItemsNotifier extends AsyncNotifier<List<Item>> {
// // // //   late final ItemRepository repo;

// // // //   @override
// // // //   Future<List<Item>> build() async {
// // // //     repo = ref.read(repositoryProvider);
// // // //     return await repo.getItems();
// // // //   }

// // // //   // -------- ADD --------
// // // //   // Future<void> addItem({
// // // //   //   required String title,
// // // //   //   String? tempImagePath,
// // // //   //   required double price,
// // // //   //   int? stock,
// // // //   //   required bool isMarket,
// // // //   // }) async {
// // // //   //   final item = Item(
// // // //   //     id: DateTime.now().millisecondsSinceEpoch.toString(),
// // // //   //     title: title,
// // // //   //     image: tempImagePath,
// // // //   //     price: price,
// // // //   //     mrpPrice: price,
// // // //   //     stock: stock,
// // // //   //     isMarket: isMarket,
// // // //   //   );

// // // //   //   await repo.addItem(item);

// // // //   //   state = AsyncValue.data(await repo.getItems());
// // // //   // }
// // // //   Future<void> addItem(Item item) async {
// // // //   print("1. save locally immediately");

// // // //   await box.put(item.id, item);

// // // //   print("2. try API (no crash if fails)");

// // // //   try {
// // // //     var request = http.MultipartRequest(
// // // //       'POST',
// // // //       Uri.parse('$baseUrl/items'),
// // // //     );

// // // //     request.fields['id'] = item.id;
// // // //     request.fields['name'] = item.title;
// // // //     request.fields['price'] = item.price.toString();
// // // //     request.fields['qty'] = (item.stock ?? 0).toString();

// // // //     if (item.image != null && item.image!.isNotEmpty) {
// // // //       request.files.add(
// // // //         await http.MultipartFile.fromPath('image', item.image!),
// // // //       );
// // // //     }

// // // //     final response = await request.send();

// // // //     final body = await response.stream.bytesToString();

// // // //     print("API STATUS: ${response.statusCode}");
// // // //     print("BODY: $body");

// // // //   } catch (e) {
// // // //     print("API ERROR: $e");
// // // //   }
// // // // }

// // // //   // -------- UPDATE --------
// // // //   Future<void> updateItem({
// // // //     required String id,
// // // //     required String title,
// // // //     String? imagePath,
// // // //     required double price,
// // // //     int? stock,
// // // //     required bool isMarket,
// // // //   }) async {
// // // //     final item = Item(
// // // //       id: id,
// // // //       title: title,
// // // //       image: imagePath,
// // // //       price: price,
// // // //       mrpPrice: price,
// // // //       stock: stock,
// // // //       isMarket: isMarket,
// // // //     );

// // // //     await repo.updateItem(item);

// // // //     state = AsyncValue.data(await repo.getItems());
// // // //   }

// // // //   // -------- DELETE --------
// // // //   Future<void> deleteItem(String id) async {
// // // //     await repo.deleteItem(id);
// // // //     state = AsyncValue.data(await repo.getItems());
// // // //   }
// // // // }
// // // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // // import 'package:hive/hive.dart';

// // // import '../models/item.dart';
// // // import '../repositories/item_repository.dart';

// // // /// ---------------- HIVE BOX PROVIDER ----------------
// // // /// This will be overridden in main.dart
// // // final hiveBoxProvider = Provider<Box<Item>>((ref) {
// // //   throw UnimplementedError(); // must override in main
// // // });

// // // /// ---------------- REPOSITORY PROVIDER ----------------
// // // /// Only pass Hive box (since API is inside repo)
// // // final repositoryProvider = Provider<ItemRepository>((ref) {
// // //   return ItemRepository(
// // //     ref.read(hiveBoxProvider), // ✅ only ONE param
// // //   );
// // // });

// // // /// ---------------- ITEMS STATE PROVIDER ----------------
// // // final itemsProvider =
// // //     AsyncNotifierProvider<ItemsNotifier, List<Item>>(ItemsNotifier.new);

// // // /// ---------------- NOTIFIER ----------------
// // // class ItemsNotifier extends AsyncNotifier<List<Item>> {
// // //   late final ItemRepository repo;

// // //   @override
// // //   Future<List<Item>> build() async {
// // //     repo = ref.read(repositoryProvider);
// // //     return await repo.getItems();
// // //   }

// // //   // ---------------- ADD ITEM ----------------
// // //   Future<void> addItem({
// // //     required String title,
// // //     String? tempImagePath,
// // //     required double price,
// // //     int? stock,
// // //     required bool isMarket,
// // //   }) async {
// // //     final item = Item(
// // //       id: DateTime.now().millisecondsSinceEpoch.toString(),
// // //       title: title,
// // //       image: tempImagePath,
// // //       price: price,
// // //       mrpPrice: price,
// // //       stock: stock,
// // //       isMarket: isMarket,
// // //     );

// // //     await repo.addItem(item);

// // //     // refresh UI
// // //     state = AsyncValue.data(await repo.getItems());
// // //   }

// // //   // ---------------- UPDATE ITEM ----------------
// // //   Future<void> updateItem({
// // //     required String id,
// // //     required String title,
// // //     String? imagePath,
// // //     required double price,
// // //     int? stock,
// // //     required bool isMarket,
// // //   }) async {
// // //     final item = Item(
// // //       id: id,
// // //       title: title,
// // //       image: imagePath,
// // //       price: price,
// // //       mrpPrice: price,
// // //       stock: stock,
// // //       isMarket: isMarket,
// // //     );

// // //     await repo.updateItem(item);

// // //     state = AsyncValue.data(await repo.getItems());
// // //   }

// // //   // ---------------- DELETE ITEM ----------------
// // //   Future<void> deleteItem(String id) async {
// // //     await repo.deleteItem(id);

// // //     state = AsyncValue.data(await repo.getItems());
// // //   }
// // // }
// // import 'dart:convert';
// // import 'package:flutter_inventory/models/item.dart';
// // import 'package:hive/hive.dart';
// // import 'package:http/http.dart' as http;

// // class ItemRepository {
// //   final String baseUrl = "https://fruits.shaidmonu300.workers.dev";
// //   final Box<Item> box;

// //   ItemRepository(this.box);

// //   // ---------------- ADD ITEM ----------------
// //   Future<void> addItem(Item item) async {
// //     try {
// //       var request = http.MultipartRequest(
// //         'POST',
// //         Uri.parse('$baseUrl/items'),
// //       );

// //       request.fields['id'] = item.id;
// //       request.fields['name'] = item.title;
// //       request.fields['price'] = item.price.toString();
// //       request.fields['qty'] = (item.stock ?? 0).toString();

// //       if (item.image != null && item.image!.isNotEmpty) {
// //         request.files.add(
// //           await http.MultipartFile.fromPath('image', item.image!),
// //         );
// //       }

// //       final response = await request.send();

// //       final body = await response.stream.bytesToString();

// //       print("ADD STATUS: ${response.statusCode}");
// //       print("ADD BODY: $body");

// //       if (response.statusCode == 200) {
// //         // ✅ After API success → refresh local
// //         await fetchAndStoreItems();
// //       }
// //     } catch (e) {
// //       print("ADD ERROR: $e");
// //     }
// //   }

// //   // ---------------- GET ITEMS FROM API ----------------
// //   Future<List<Item>> fetchFromApi() async {
// //     final res = await http.get(Uri.parse('$baseUrl/items'));

// //     print("GET STATUS: ${res.statusCode}");
// //     print("GET BODY: ${res.body}");

// //     if (res.statusCode == 200) {
// //       final data = jsonDecode(res.body);

// //       return (data as List).map((e) => Item.fromJson(e)).toList();
// //     } else {
// //       throw Exception("Failed to load items");
// //     }
// //   }

// //   // ---------------- SAVE API DATA TO HIVE ----------------
// //   Future<void> fetchAndStoreItems() async {
// //     final items = await fetchFromApi();

// //     await box.clear(); // optional but clean

// //     for (final item in items) {
// //       await box.put(item.id, item);
// //     }
// //   }

// //   // ---------------- GET ITEMS (UI USES THIS) ----------------
// //   Future<List<Item>> getItems() async {
// //     // Always refresh from API first
// //     await fetchAndStoreItems();

// //     return box.values.toList().toList();
// //   }

// //   // ---------------- DELETE ----------------
// //   Future<void> deleteItem(String id) async {
// //     try {
// //       final res = await http.delete(Uri.parse('$baseUrl/items/$id'));

// //       print("DELETE STATUS: ${res.statusCode}");

// //       if (res.statusCode == 200) {
// //         await fetchAndStoreItems();
// //       }
// //     } catch (e) {
// //       print("DELETE ERROR: $e");
// //     }
// //   }

// //   // ---------------- UPDATE ----------------
// //   Future<void> updateItem(Item item) async {
// //     try {
// //       final res = await http.put(
// //         Uri.parse('$baseUrl/items/${item.id}'),
// //         headers: {'Content-Type': 'application/json'},
// //         body: jsonEncode({
// //           "name": item.title,
// //           "price": item.price,
// //           "qty": item.stock ?? 0,
// //           "image": item.image ?? "",
// //         }),
// //       );

// //       print("UPDATE STATUS: ${res.statusCode}");

// //       if (res.statusCode == 200) {
// //         await fetchAndStoreItems();
// //       }
// //     } catch (e) {
// //       print("UPDATE ERROR: $e");
// //     }
// //   }
// // }
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hive/hive.dart';

// import '../models/item.dart';
// import '../repositories/item_repository.dart';

// final hiveBoxProvider = Provider<Box<Item>>((ref) {
//   throw UnimplementedError();
// });

// final repositoryProvider = Provider<ItemRepository>((ref) {
//   final box = ref.read(hiveBoxProvider);
//   return ItemRepository(box);
// });

// final itemsProvider =
//     AsyncNotifierProvider<ItemsNotifier, List<Item>>(ItemsNotifier.new);

// class ItemsNotifier extends AsyncNotifier<List<Item>> {
//   late final ItemRepository repo;

//   @override
//   Future<List<Item>> build() async {
//     repo = ref.read(repositoryProvider);
//     return await repo.getItems();
//   }

//   Future<void> addItem({
//     required String title,
//     String? tempImagePath,
//     required double price,
//     int? stock,
//     required bool isMarket,
//   }) async {
//     state = const AsyncValue.loading();

//     final item = Item(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       title: title,
//       image: tempImagePath,
//       price: price,
//       mrpPrice: price,
//       stock: stock,
//       isMarket: isMarket,
//     );

//     await repo.addItem(item);

//     state = AsyncValue.data(await repo.getItems());
//   }

//   Future<void> updateItem({
//     required String id,
//     required String title,
//     String? imagePath,
//     required double price,
//     int? stock,
//     required bool isMarket,
//   }) async {
//     state = const AsyncValue.loading();

//     final item = Item(
//       id: id,
//       title: title,
//       image: imagePath,
//       price: price,
//       mrpPrice: price,
//       stock: stock,
//       isMarket: isMarket,
//     );

//     await repo.updateItem(item);

//     state = AsyncValue.data(await repo.getItems());
//   }

//   Future<void> deleteItem(String id) async {
//     state = const AsyncValue.loading();

//     await repo.deleteItem(id);

//     state = AsyncValue.data(await repo.getItems());
//   }
// }
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../models/item.dart';
import '../services/item_api_service.dart';
import '../repositories/item_repository.dart';

// Hive Box
final hiveBoxProvider = Provider<Box<Item>>((ref) {
  throw UnimplementedError();
});

// API
final apiProvider = Provider<ItemApiService>((ref) {
  return ItemApiService();
});

// Repository
final repositoryProvider = Provider<ItemRepository>((ref) {
  return ItemRepository(
    ref.read(hiveBoxProvider),
    ref.read(apiProvider), // ✅ REQUIRED
  );
});

// Notifier
final itemsProvider =
    AsyncNotifierProvider<ItemsNotifier, List<Item>>(ItemsNotifier.new);

class ItemsNotifier extends AsyncNotifier<List<Item>> {
  late ItemRepository repo;

  @override
  Future<List<Item>> build() async {
    repo = ref.read(repositoryProvider);
    return repo.getItems();
  }

  Future<void> addItem({
    required String title,
    String? tempImagePath,
    required double price,
    int? stock,
    required bool isMarket,
  }) async {
    final item = Item(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      image: tempImagePath,
      price: price,
      mrpPrice: price,
      stock: stock,
      isMarket: isMarket,
    );

    await repo.addItem(item);

    // refresh UI
    state = AsyncValue.data(await repo.getItems());
  }

  Future<void> updateItem({
    required String id,
    required String title,
    String? imagePath,
    required double price,
    int? stock,
    required bool isMarket,
  }) async {
    final item = Item(
      id: id,
      title: title,
      image: imagePath,
      price: price,
      mrpPrice: price,
      stock: stock,
      isMarket: isMarket,
    );

    await repo.updateItem(item);
    state = AsyncValue.data(await repo.getItems());
  }

  Future<void> deleteItem(String id) async {
    await repo.deleteItem(id);
    state = AsyncValue.data(await repo.getItems());
  }
}
