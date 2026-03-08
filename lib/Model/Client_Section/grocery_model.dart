class GroceryItemModel {
  final String id;
  final String name;
  final bool isBought;

  GroceryItemModel({
    required this.id,
    required this.name,
    required this.isBought,
  });

  factory GroceryItemModel.fromJson(Map<String, dynamic> json) {
    return GroceryItemModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      isBought: json['isBought'] ?? false,
    );
  }
}

class GroceryListModel {
  final String id;
  final String title;
  final List<GroceryItemModel> items;
  final DateTime? createdAt;

  GroceryListModel({
    required this.id,
    required this.title,
    required this.items,
    this.createdAt,
  });

  factory GroceryListModel.fromJson(Map<String, dynamic> json) {
    return GroceryListModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      items: (json['items'] as List?)
              ?.map((item) => GroceryItemModel.fromJson(item))
              .toList() ??
          [],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }
}

class PantryItemModel {
  final String id;
  final String name;

  PantryItemModel({
    required this.id,
    required this.name,
  });

  factory PantryItemModel.fromJson(Map<String, dynamic> json) {
    return PantryItemModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
