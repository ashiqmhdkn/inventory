// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/item.dart';

// class ItemApiService {
//   static const String baseUrl = 'https://fruits.shaidmonu300.workers.dev';

//   // ---------------- GET ----------------
//   Future<List<Item>> getItems() async {
//     final res = await http.get(Uri.parse('$baseUrl/items'));

//     if (res.statusCode == 200) {
//       final data = jsonDecode(res.body) as List;
//       return data.map((e) => Item.fromJson(e)).toList();
//     } else {
//       throw Exception('Failed to fetch items');
//     }
//   }

//   // ---------------- POST ----------------
//   Future<bool> createItem(Item item) async {
//     final res = await http.post(
//       Uri.parse('$baseUrl/items'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(item.toJson()),
//     );

//     return res.statusCode == 200 || res.statusCode == 201;
//   }

//   // ---------------- PUT ----------------
//   Future<bool> updateItem(Item item) async {
//     final res = await http.put(
//       Uri.parse('$baseUrl/items/${item.id}'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(item.toJson()),
//     );

//     return res.statusCode == 200;
//   }

//   // ---------------- DELETE ----------------
//   Future<bool> deleteItem(String id) async {
//     final res = await http.delete(Uri.parse('$baseUrl/items/$id'));

//     return res.statusCode == 200;
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/item.dart';

class ItemApiService {
  final String baseUrl = "https://fruits.shaidmonu300.workers.dev";

  // GET ITEMS
  Future<List<Item>> fetchItems() async {
    final res = await http.get(Uri.parse("$baseUrl/items"));

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => Item.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch items");
    }
  }

  // ADD ITEM
  // Future<void> addItem(Item item) async {
  //   var request = http.MultipartRequest(
  //     'POST',
  //     Uri.parse("$baseUrl/items"),
  //   );

  //   request.fields.addAll(item.toApiMap());

  //   if (item.image != null && item.image!.isNotEmpty) {
  //     request.files.add(
  //       await http.MultipartFile.fromPath("image", item.image!),
  //     );
  //   }

  //   final response = await request.send();
  //   print("POST STATUS: ${response.statusCode}");
  // }
  Future<void> addItem(Item item) async {
    final response = await http.post(
      Uri.parse("$baseUrl/items"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        // "id": 22,
        // "name": item.title,
        // "price": item.price,
        // "qty": item.stock ?? 0,
        // "image": item.image ?? "",
        {"id": "123", "name": "Apple", "price": 25, "qty": 5, "image": ""}
      }),
    );

    print("POST STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");
  }

  // DELETE
  Future<void> deleteItem(String id) async {
    await http.delete(Uri.parse("$baseUrl/items/$id"));
  }

  // UPDATE
  Future<void> updateItem(Item item) async {
    await http.put(
      Uri.parse("$baseUrl/items/${item.id}"),
      body: item.toApiMap(),
    );
  }
}
