import 'dart:convert';
import 'package:flutter_inventory/models/apiitem.dart';
import 'package:http/http.dart' as http;

const String baseUrl = 'https://fruits.shaidmonu300.workers.dev';

// ---------------- GET ----------------
Future<List<Item>> getApiItems() async {
  final res = await http.get(Uri.parse('$baseUrl/items'));
print("getItems response: ");
  if (res.statusCode == 200) {
    final data = jsonDecode(res.body);

    // Case 1: { items: [...] }
    if (data is Map && data['items'] is List) {
      return (data['items'] as List).map((e) => Item.fromMap(e)).toList();
    }

    // Case 2: direct list []
    if (data is List) {
      return data.map((e) => Item.fromMap(e)).toList();
    }

    return [];
  } else {
    throw Exception("API failed");
  }
}

// ---------------- POST ----------------
Future<bool> createApiItem(Item item) async {
    print("------------------------------api call createItem(item)--------------------${item.id} ${item.title} ${item.price}");
  final res = await http.post(
    Uri.parse('$baseUrl/items'),
    headers: {'Content-Type': 'application/json'
    },
    body: jsonEncode(item.toMap()),
  );
  print("..........Create api..............");
  print(res.statusCode);
  print("body: ${res.body}");
  print("request body: ${jsonEncode(item.toMap())}");

  if (res.statusCode == 200 || res.statusCode == 201) {
    return true;
  } else {
    return false;
  }
}

// ---------------- PUT ----------------
Future<bool> updateApiItem(Item item) async {
  print("------------------------------api call updateItem(item)--------------------${item.id} ${item.title} ${item.price}");
  final res = await http.put(
    Uri.parse('$baseUrl/items/${item.id}'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(item.toMap()),
  );
  print("..........Update api..............");
  print(res.statusCode);
  print(res.body);


  if (res.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

// ---------------- DELETE ----------------
Future<bool> deleteApiItem(String id) async {
  final res = await http.delete(Uri.parse('$baseUrl/items/$id'));

  return res.statusCode == 200;
}
