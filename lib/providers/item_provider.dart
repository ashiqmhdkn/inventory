import 'package:flutter_inventory/models/apiitem.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/item_api_service.dart';


class ItemProvider extends AsyncNotifier<List<Item>> {
  @override
  Future<List<Item>> build() async {
    return getItems();
  }

  // ---------------- CREATE ----------------
  Future<bool> createItem({
    required String name,
    required double price,
    int? quantity,
  String? image,
  }) async {
    try {
      final success = await createItem(
        name: name,
        price: price,
        quantity: quantity,
        image: image,
      );

      if (success) {
        state = await AsyncValue.guard(() => getItems());
      }

      return success;
    } catch (e) {
      return false;
    }
  }

  // ---------------- UPDATE ----------------
  Future<bool> updateItem({
    required String id,
    required String name,
    required double price,
    int? quantity,
    String? image,
  }) async {
    try {
      final success = await updateItem(
        id: id,
        name: name,
        price: price,
        quantity: quantity,
        image: image,
      );

      if (success) {
        state = const AsyncValue.loading();
        state = await AsyncValue.guard(() => getItems());
      }

      return success;
    } catch (e) {
      return false;
    }
  }

  // ---------------- DELETE ----------------
  Future<bool> deleteItem(String id) async {
    try {
      final success = await deleteItem(id);

      if (success) {
        state = const AsyncValue.loading();
        state = await AsyncValue.guard(() => getItems());
      }

      return success;
    } catch (e) {
      return false;
    }
  }

  // ---------------- REFRESH ----------------
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => getItems());
  }
}
final itemProvider = AsyncNotifierProvider<ItemProvider, List<Item>>(() => ItemProvider());