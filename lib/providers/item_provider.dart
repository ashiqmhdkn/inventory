import 'package:flutter_inventory/models/apiitem.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/item_api_service.dart';

class ItemProvider extends AsyncNotifier<List<Item>> {
  @override
  Future<List<Item>> build() async {
    return getApiItems();
  }

  // ---------------- CREATE ----------------
  Future<bool> createItem({
    required String name,
    required double price,
    required String id,
    int? quantity,
    String? image,
  }) async {
    print("..........create..............");
    print(name);
    print(price);
    print(quantity);
    print(image);
    try {
      final success = await createApiItem(
        Item(
          id: id,
          title: name,
          price: price,
          stock: quantity,
          image: image,
        ),
      );

      if (success) {
        state = await AsyncValue.guard(() => getApiItems());
      }

      return success;
    } catch (e) {
      return false;
    }
  }

  // ---------------- UPDATE ----------------
  Future<bool> EditItem({
    required String id,
    required String name,
    required double price,
    int? quantity,
    String? image,
  }) async {
    print("item_provider updateItem called with id: $id, name: $name, price: $price, quantity: $quantity, image: $image");
    try {
      print("..........update..............");
      print(name);
      print(price);
      print(quantity);
      print(image);
      final success = await updateApiItem(
        Item(
          id: id,
          title: name,
          price: price,
          stock: quantity,
          image: image,
        ),
      );

      if (success) {
        state = const AsyncValue.loading();
        state = await AsyncValue.guard(() => getApiItems());
      }

      return success;
    } catch (e) {
      return false;
    }
  }

  // ---------------- DELETE ----------------
  Future<bool> removeItem(String id) async {
    try {
      final success = await deleteApiItem(id);

      if (success) {
        state = const AsyncValue.loading();
        state = await AsyncValue.guard(() => getApiItems());
      }

      return success;
    } catch (e) {
      return false;
    }
  }

  // ---------------- REFRESH ----------------
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => getApiItems());
  }
}

final itemProvider =
    AsyncNotifierProvider<ItemProvider, List<Item>>(() => ItemProvider());

