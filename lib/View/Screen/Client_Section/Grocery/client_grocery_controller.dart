import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroceryItem {
  String name;
  bool isChecked;

  GroceryItem({required this.name, this.isChecked = false});
}

class GroceryListModel {
  String name;
  List<GroceryItem> items;

  GroceryListModel({required this.name, required this.items});
}

class ClientGroceryController extends GetxController {
  // Logic for managing lists and items

  var groceryLists = <GroceryListModel>[].obs;
  var currentListItems = <GroceryItem>[].obs;
  var pantryItems = <String>[].obs;

  final TextEditingController newListController = TextEditingController();
  final TextEditingController newItemController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Mock Data
    groceryLists.add(GroceryListModel(name: "My Grocery List", items: []));

    pantryItems.add("Dark chocolate");

    currentListItems.addAll([
      GroceryItem(name: "Oats"),
      GroceryItem(name: "Dates"),
      GroceryItem(name: "Cacao powder"),
      GroceryItem(name: "Vanilla extract"),
      GroceryItem(name: "Dark chocolate", isChecked: true),
      GroceryItem(name: "Almond butter", isChecked: true),
    ]);
  }

  void toggleItem(int index) {
    var item = currentListItems[index];
    item.isChecked = !item.isChecked;
    currentListItems.refresh();
  }

  void addItem() {
    if (newItemController.text.isNotEmpty) {
      currentListItems.add(GroceryItem(name: newItemController.text));
      newItemController.clear();
    }
  }

  void removeItem(int index) {
    currentListItems.removeAt(index);
  }
}
