import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../Model/Client_Section/meal_model.dart';
import '../Home/client_home_controller.dart';

class ClientSearchController extends GetxController {
  // Accessing Home Controller to get the master list of meals, or defines its own
  // For now, let's mock the specific search results shown in the image or filter from home

  final TextEditingController searchController = TextEditingController();
  final RxList<MealModel> searchResults = <MealModel>[].obs;

  // Filter State
  var isFilterVisible = false.obs;
  var selectedPhase = "All phases".obs;
  var selectedMealType = "All types".obs;
  final TextEditingController maxCaloriesController = TextEditingController();
  var selectedFeeling = "Select feeling".obs;
  var selectedNutrients = <String>[].obs;

  void toggleFilterVisibility() {
    isFilterVisible.value = !isFilterVisible.value;
  }

  void toggleNutrient(String nutrient) {
    if (selectedNutrients.contains(nutrient)) {
      selectedNutrients.remove(nutrient);
    } else {
      selectedNutrients.add(nutrient);
    }
  }

  // Store all meals to filter from
  List<MealModel> allMeals = [];

  @override
  void onInit() {
    super.onInit();
    // Initialize with mostly all meals or specific ones for the demo
    try {
      final homeController = Get.find<ClientHomeController>();
      allMeals = homeController.meals;
    } catch (e) {
      allMeals = [
        MealModel(
          imageUrl:
              'https://images.unsplash.com/photo-1525351484163-7529414395d8?q=80&w=600',
          title: "AVOCADO TOAST WITH EGGS",
          time: "15m",
          servings: "1",
          calories: "420 cal",
          description:
              "A nutritious and satisfying breakfast packed with healthy fats, protein, and fiber to keep you energized",
          isFavorite: false,
          tags: ["Breakfast", "Protein"],
          nutrition: {"Protein": "15g", "Carbs": "20g"},
          ingredients: {"Avocado": "1", "Eggs": "2", "Bread": "2 slices"},
          instructions: ["Toast bread", "Fry eggs", "Mash avocado", "Assemble"],
        ),
        MealModel(
          imageUrl:
              'https://images.unsplash.com/photo-1467003909585-2f8a7270028d?q=80&w=600',
          title: "SALMON QUINOA POWER BOWL",
          time: "25m",
          servings: "1",
          calories: "520 cal",
          description:
              "A complete meal with lean protein, whole grains, and fresh vegetables, perfect for sustained energy and hormone balance.",
          isFavorite: true,
          tags: ["Lunch", "Omega-3"],
          nutrition: {"Protein": "30g", "Carbs": "45g"},
          ingredients: {"Salmon": "150g", "Quinoa": "1 cup"},
          instructions: ["Cook quinoa", "Grill salmon", "Mix visuals"],
        ),
      ];
    }
    // Initially show all
    searchResults.value = allMeals;
  }

  void filterMeals(String query) {
    if (query.isEmpty) {
      searchResults.value = allMeals;
    } else {
      searchResults.value = allMeals.where((meal) {
        final title = meal.title.toLowerCase();
        final description = meal.description.toLowerCase();
        final ingredients = meal.ingredients.keys.join(" ").toLowerCase();
        final searchLower = query.toLowerCase();
        return title.contains(searchLower) ||
            description.contains(searchLower) ||
            ingredients.contains(searchLower);
      }).toList();
    }
  }
}
