import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Model/Client_Section/grocery_model.dart';
import '../../../../helper/shared_prefe/shared_prefe.dart';
import '../../../../helper/toast_helper.dart';
import '../../../../service/api_url.dart';

class ClientGroceryController extends GetxController {
  var isLoading = false.obs;
  
  // Lists and Pantry
  var groceryLists = <GroceryListModel>[].obs;
  var pantryItems = <PantryItemModel>[].obs;
  
  // Track selected list
  var selectedList = Rxn<GroceryListModel>();
  
  // Controllers
  final TextEditingController newListController = TextEditingController();
  final TextEditingController newItemController = TextEditingController();
  final TextEditingController newPantryItemController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getAllData();
  }

  void getAllData() async {
    isLoading.value = true;
    await Future.wait([
      getAllLists(),
      getPantry(),
    ]);
    isLoading.value = false;
  }

  // === 1. PANTRY MANAGEMENT ===

  Future<void> getPantry() async {
    try {
      final token = await SharePrefsHelper.getString(SharedPreferenceValue.token);
      final response = await GetConnect().get(
        "${ApiConstant.baseUrl}${ApiConstant.grocery}/pantry",
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        // According to your JSON: Response -> data -> items
        var rawBody = response.body;
        var dataPart = rawBody['data'];
        
        List itemsList = [];
        if (dataPart != null && dataPart['items'] != null) {
          itemsList = dataPart['items'];
        } else if (dataPart is List) {
          itemsList = dataPart;
        }

        pantryItems.value = itemsList.map((json) => PantryItemModel.fromJson(json)).toList();
        debugPrint("Pantry loaded: ${pantryItems.length} items");
      }
    } catch (e) {
      debugPrint("Pantry Load Error: $e");
    }
  }

  Future<void> addPantryItem() async {
    if (newPantryItemController.text.trim().isEmpty) return;
    try {
      final token = await SharePrefsHelper.getString(SharedPreferenceValue.token);
      final response = await GetConnect().post(
        "${ApiConstant.baseUrl}${ApiConstant.grocery}/pantry",
        {"name": newPantryItemController.text.trim()},
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        newPantryItemController.clear();
        getPantry();
      } else {
        ToastHelper.showError(response.body['message'] ?? "Failed to add to pantry");
      }
    } catch (e) {
      ToastHelper.showError("Network error: $e");
    }
  }

  Future<void> removePantryItem(String itemId) async {
    try {
      final token = await SharePrefsHelper.getString(SharedPreferenceValue.token);
      final response = await GetConnect().delete(
        "${ApiConstant.baseUrl}${ApiConstant.grocery}/pantry/$itemId",
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        getPantry();
      }
    } catch (e) {
      ToastHelper.showError("Network error: $e");
    }
  }

  // === 2. GROCERY LIST MANAGEMENT ===

  Future<void> getAllLists() async {
    try {
      final token = await SharePrefsHelper.getString(SharedPreferenceValue.token);
      final response = await GetConnect().get(
        "${ApiConstant.baseUrl}${ApiConstant.grocery}",
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List data = response.body['data'] ?? [];
        groceryLists.value = data.map((json) => GroceryListModel.fromJson(json)).toList();
        
        // Auto-select first list if nothing selected
        if (groceryLists.isNotEmpty && selectedList.value == null) {
          selectedList.value = groceryLists[0];
        } else if (selectedList.value != null) {
           // Refresh selected list items
           final updated = groceryLists.firstWhereOrNull((l) => l.id == selectedList.value!.id);
           if (updated != null) selectedList.value = updated;
        }
      }
    } catch (e) {
      debugPrint("Grocery Lists Load Error: $e");
    }
  }

  Future<void> createList() async {
    if (newListController.text.trim().isEmpty) return;
    try {
      final token = await SharePrefsHelper.getString(SharedPreferenceValue.token);
      final response = await GetConnect().post(
        "${ApiConstant.baseUrl}${ApiConstant.grocery}",
        {"title": newListController.text.trim()},
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        newListController.clear();
        getAllLists();
        ToastHelper.showSuccess("List created successfully");
      }
    } catch (e) {
      ToastHelper.showError("Network error: $e");
    }
  }

  Future<void> deleteList(String id) async {
    try {
      final token = await SharePrefsHelper.getString(SharedPreferenceValue.token);
      final response = await GetConnect().delete(
        "${ApiConstant.baseUrl}${ApiConstant.grocery}/$id",
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        if (selectedList.value?.id == id) selectedList.value = null;
        getAllLists();
      }
    } catch (e) {
      ToastHelper.showError("Network error: $e");
    }
  }

  // === 3. ITEM MANAGEMENT ===

  Future<void> addItem() async {
    if (newItemController.text.trim().isEmpty || selectedList.value == null) return;
    try {
      final token = await SharePrefsHelper.getString(SharedPreferenceValue.token);
      final response = await GetConnect().post(
        "${ApiConstant.baseUrl}${ApiConstant.grocery}/${selectedList.value!.id}/items",
        {"name": newItemController.text.trim()},
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        newItemController.clear();
        getAllLists();
      }
    } catch (e) {
      ToastHelper.showError("Network error: $e");
    }
  }

  Future<void> toggleItem(String itemId) async {
    if (selectedList.value == null) return;
    try {
      final token = await SharePrefsHelper.getString(SharedPreferenceValue.token);
      final response = await GetConnect().patch(
        "${ApiConstant.baseUrl}${ApiConstant.grocery}/${selectedList.value!.id}/items/$itemId/toggle",
        {},
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        getAllLists();
      }
    } catch (e) {
      ToastHelper.showError("Network error: $e");
    }
  }

  Future<void> deleteItem(String itemId) async {
    if (selectedList.value == null) return;
    try {
      final token = await SharePrefsHelper.getString(SharedPreferenceValue.token);
      final response = await GetConnect().delete(
        "${ApiConstant.baseUrl}${ApiConstant.grocery}/${selectedList.value!.id}/items/$itemId",
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        getAllLists();
      }
    } catch (e) {
      ToastHelper.showError("Network error: $e");
    }
  }

  Future<void> moveToPantry(String itemId) async {
    if (selectedList.value == null) return;
    try {
      final token = await SharePrefsHelper.getString(SharedPreferenceValue.token);
      final response = await GetConnect().post(
        "${ApiConstant.baseUrl}${ApiConstant.grocery}/${selectedList.value!.id}/items/$itemId/move-to-pantry",
        {},
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        getAllLists();
        getPantry();
        ToastHelper.showSuccess("Moved to Pantry");
      }
    } catch (e) {
      ToastHelper.showError("Network error: $e");
    }
  }

  @override
  void onClose() {
    newListController.dispose();
    newItemController.dispose();
    newPantryItemController.dispose();
    super.onClose();
  }
}
