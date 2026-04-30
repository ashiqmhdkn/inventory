import 'dart:convert';
import 'package:flutter_inventory/models/apiitem.dart';
import 'package:http/http.dart' as http;

 const String baseUrl = 'https://fruits.shaidmonu300.workers.dev';

  // ---------------- GET ----------------
  Future<List<Item>> getItems() async {
  final res = await http.get(Uri.parse('$baseUrl/items'));

  if (res.statusCode == 200) {
    final data = jsonDecode(res.body);

    // Case 1: { items: [...] }
    if (data is Map && data['items'] is List) {
      return (data['items'] as List)
          .map((e) => Item.fromMap(e))
          .toList();
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
  Future<bool> createItem(Item item) async {
    final res = await http.post(
      Uri.parse('$baseUrl/items'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(item.toMap()),
    );

    return res.statusCode == 200 || res.statusCode == 201;
  }

  // ---------------- PUT ----------------
  Future<bool> updateItem(Item item) async {
    final res = await http.put(
      Uri.parse('$baseUrl/items/${item.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(item.toMap()),
    );

    return res.statusCode == 200;
  }

  // ---------------- DELETE ----------------
  Future<bool> deleteItem(String id) async {
    final res = await http.delete(Uri.parse('$baseUrl/items/$id'));

    return res.statusCode == 200;
  }

