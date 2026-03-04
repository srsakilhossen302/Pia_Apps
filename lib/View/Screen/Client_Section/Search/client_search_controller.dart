import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Model/Client_Section/recipe_model.dart';
import '../../../../helper/shared_prefe/shared_prefe.dart';
import '../../../../helper/toast_helper.dart';
import '../../../../service/api_url.dart';

class ClientSearchController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxList<RecipeModel> searchResults = <RecipeModel>[].obs;
  final RxBool isLoading = false.obs;

  // Filter State
  var isFilterVisible = false.obs;
  var selectedPhase = "All phases".obs;
  var selectedMealType = "All types".obs;
  final TextEditingController maxCaloriesController = TextEditingController();
  final RxString maxCalories = "".obs; // Reactive variable for calories
  var selectedFeeling = "Select feeling".obs;
  var selectedNutrients = <String>[].obs;

  final RxString searchQuery = "".obs;

  @override
  void onInit() {
    super.onInit();

    // Listen to search query with debounce
    debounce(
      searchQuery,
      (_) => searchRecipes(),
      time: const Duration(milliseconds: 800),
    );

    // Listen to filters immediately
    ever(selectedPhase, (_) => searchRecipes());
    ever(selectedMealType, (_) => searchRecipes());
    ever(selectedFeeling, (_) => searchRecipes());
    // For list, we need to trigger manually or use a specific way, but ever works if the list instance is updated or we use refresh
    // But modifying the list in place might not trigger 'ever' on the list variable itself unless we use .assign or similar.
    // However, in toggleNutrient we can call searchRecipes directly.

    // Listen to max calories debounce
    debounce(
      maxCalories,
      (_) => searchRecipes(),
      time: const Duration(milliseconds: 800),
    );

    // Initial load
    searchRecipes();
  }

  void toggleFilterVisibility() {
    isFilterVisible.value = !isFilterVisible.value;
  }

  void toggleNutrient(String nutrient) {
    if (selectedNutrients.contains(nutrient)) {
      selectedNutrients.remove(nutrient);
    } else {
      selectedNutrients.add(nutrient);
    }
    // Trigger search manually since observing list mutations can be tricky
    searchRecipes();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void updateMaxCalories(String val) {
    maxCalories.value = val;
  }

  Future<void> searchRecipes() async {
    isLoading.value = true;
    try {
      final token = await SharePrefsHelper.getString(
        SharedPreferenceValue.token,
      );

      Map<String, dynamic> queryParams = {};

      if (searchQuery.value.isNotEmpty) {
        queryParams['searchTerm'] = searchQuery.value;
      }

      if (selectedPhase.value != "All phases") {
        queryParams['phases'] = selectedPhase.value;
      }

      if (selectedMealType.value != "All types") {
        queryParams['category'] = selectedMealType.value;
      }

      if (maxCalories.value.isNotEmpty) {
        queryParams['maxCalories'] = maxCalories.value;
      }

      if (selectedFeeling.value != "Select feeling") {
        queryParams['feelings'] = selectedFeeling.value;
      }

      if (selectedNutrients.isNotEmpty) {
        // API likely expects comma separated or multiple keys.
        // Based on user input "?searchTerm=...&nutrients=dsfsdfsd", it seems to be a single string parameter.
        // If multiple nutrients, we join them.
        queryParams['nutrients'] = selectedNutrients.join(",");
      }

      final response = await GetConnect().get(
        "${ApiConstant.baseUrl}${ApiConstant.recipe}",
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        query: queryParams.map((key, value) => MapEntry(key, value.toString())),
      );

      if (response.statusCode == 200) {
        final recipeResponse = RecipeResponseModel.fromJson(response.body);
        searchResults.assignAll(recipeResponse.data ?? []);
      } else {
        // If 404, it might mean no results found
        if (response.statusCode == 404) {
          searchResults.clear();
        } else {
          // Only show error if it's not a 404 (which is expected for empty search sometimes)
          // But usually APIs return empty list for 200 if no match.
          // Let's assume 200 with empty list is standard, but if 404 is used for "not found", we handle it.
          searchResults.clear();
          // print("Error fetching recipes: ${response.body}");
        }
      }
    } catch (e) {
      ToastHelper.showError("Network error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
