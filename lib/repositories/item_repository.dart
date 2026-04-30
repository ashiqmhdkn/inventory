// // // import 'package:hive/hive.dart';
// // // import '../models/item.dart';
// // // import '../services/item_api_service.dart';

// // // class ItemRepository {
// // //   final Box<Item> box;
// // //   final ItemApiService api;

// // //   ItemRepository(this.box, this.api);

// // //   // ---------------- GET ----------------
// // //   Future<List<Item>> getItems() async {
// // //     // 1. return local first
// // //     final localItems = box.values.toList();

// // //     // 2. try API (background sync)
// // //     try {
// // //       final remoteItems = await api.getItems();

// // //       // replace local with fresh data
// // //       await box.clear();
// // //       for (var item in remoteItems) {
// // //         await box.put(item.id, item);
// // //       }

// // //       return remoteItems;
// // //     } catch (_) {
// // //       // offline fallback
// // //       return localItems;
// // //     }
// // //   }

// // //   // ---------------- ADD ----------------
// // //   Future<void> addItem(Item item) async {
// // //     // 1. save locally immediately
// // //     print("............save..............");
// // //     await box.put(item.id, item);
// // //     print("1. save locally immediately");

// // //     // 2. try API (no crash if fails)
// // //     try {
// // //       await api.createItem(item);
// // //       print("2. try API (no crash if fails)");
// // //     } catch (_) {
// // //       print("Error");
// // //     }
// // //   }

// // //   // ---------------- UPDATE ----------------
// // //   Future<void> updateItem(Item item) async {
// // //     await box.put(item.id, item);

// // //     try {
// // //       await api.updateItem(item);
// // //     } catch (_) {}
// // //   }

// // //   // ---------------- DELETE ----------------
// // //   Future<void> deleteItem(String id) async {
// // //     await box.delete(id);

// // //     try {
// // //       await api.deleteItem(id);
// // //     } catch (_) {}
// // //   }
// // // }

// // import 'package:flutter_inventory/models/item.dart';
// // import 'package:hive/hive.dart';
// // import 'package:http/http.dart' as http;

// // class ItemRepository {
// //   final String baseUrl = "https://fruits.shaidmonu300.workers.dev";

// //   final Box<Item> box;

// //   ItemRepository(this.box);

// //   Future<void> addItem(Item item) async {
// //     print("1. save locally immediately");

// //     // ✅ STEP 1: Save to Hive
// //     await box.put(item.id, item);

// //     print("2. try API (no crash if fails)");

// //     try {
// //       var request = http.MultipartRequest(
// //         'POST',
// //         Uri.parse('$baseUrl/items'),
// //       );

// //       // ✅ IMPORTANT: API FIELD MAPPING
// //       request.fields['id'] = item.id;
// //       request.fields['name'] = item.title;
// //       request.fields['price'] = item.price.toString();
// //       request.fields['qty'] = (item.stock ?? 0).toString();

// //       // ✅ IMAGE
// //       if (item.image != null && item.image!.isNotEmpty) {
// //         request.files.add(
// //           await http.MultipartFile.fromPath(
// //             'image',
// //             item.image!,
// //           ),
// //         );
// //       }

// //       final response = await request.send();

// //       print("API STATUS: ${response.statusCode}");

// //       if (response.statusCode != 200) {
// //         print("API FAILED");
// //       }
// //     } catch (e) {
// //       print("API ERROR: $e");
// //     }
// //   }
// // }
// import 'dart:convert';
// import 'package:hive/hive.dart';
// import 'package:http/http.dart' as http;
// import '../models/item.dart';

// class ItemRepository {
//   final String baseUrl = "https://fruits.shaidmonu300.workers.dev";

//   final Box<Item> box;

//   ItemRepository(this.box);

//   // ---------------- GET ----------------
//   Future<List<Item>> getItems() async {
//     try {
//       final res = await http.get(Uri.parse('$baseUrl/items'));

//       if (res.statusCode == 200) {
//         final data = jsonDecode(res.body);

//         final items = (data as List)
//             .map((e) => Item.fromJson(e))
//             .toList();

//         // ✅ SAVE TO HIVE
//         await box.clear();
//         for (var item in items) {
//           await box.put(item.id, item);
//         }

//         return items;
//       } else {
//         throw Exception("API failed");
//       }
//     } catch (e) {
//       // ✅ OFFLINE → return Hive data
//       return box.values.toList();
//     }
//   }

//   // ---------------- ADD ----------------
//   Future<void> addItem(Item item) async {
//     // 1️⃣ API FIRST
//     var request = http.MultipartRequest(
//       'POST',
//       Uri.parse('$baseUrl/items'),
//     );

//     request.fields['id'] = item.id;
//     request.fields['name'] = item.title;
//     request.fields['price'] = item.price.toString();
//     request.fields['qty'] = (item.stock ?? 0).toString();

//     if (item.image != null && item.image!.isNotEmpty) {
//       request.files.add(
//         await http.MultipartFile.fromPath('image', item.image!),
//       );
//     }

//     final res = await request.send();

//     if (res.statusCode != 200) {
//       throw Exception("API ADD FAILED");
//     }

//     // 2️⃣ GET UPDATED LIST → SAVE TO HIVE
//     await getItems();
//   }

//   // ---------------- UPDATE ----------------
//   Future<void> updateItem(Item item) async {
//     final res = await http.put(
//       Uri.parse('$baseUrl/items/${item.id}'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(item.toJson()),
//     );

//     if (res.statusCode != 200) {
//       throw Exception("UPDATE FAILED");
//     }

//     await getItems();
//   }

//   // ---------------- DELETE ----------------
//   Future<void> deleteItem(String id) async {
//     final res =
//         await http.delete(Uri.parse('$baseUrl/items/$id'));

//     if (res.statusCode != 200) {
//       throw Exception("DELETE FAILED");
//     }

//     await getItems();
//   }
// }
import 'package:hive/hive.dart';
import '../models/item.dart';
import '../services/item_api_service.dart';

class ItemRepository {
  final Box<Item> box;
  final ItemApiService api;

  ItemRepository(this.box, this.api);

  // 🔥 MAIN LOGIC
  Future<List<Item>> getItems() async {
    try {
      // 1. Fetch from API
      final items = await api.fetchItems();

      // 2. Save to Hive
      await box.clear();
      for (var item in items) {
        await box.put(item.id, item);
      }

      return items;
    } catch (e) {
      print("API FAILED → fallback to Hive");
      return box.values.toList();
    }
  }

  Future<void> addItem(Item item) async {
    // 1. Send to API FIRST
    await api.addItem(item);

    // 2. Fetch updated list
    await getItems();
  }

  Future<void> updateItem(Item item) async {
    await api.updateItem(item);
    await getItems();
  }

  Future<void> deleteItem(String id) async {
    await api.deleteItem(id);
    await getItems();
  }
}
