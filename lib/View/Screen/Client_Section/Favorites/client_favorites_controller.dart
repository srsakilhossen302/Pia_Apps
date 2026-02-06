import 'package:get/get.dart';
import '../../../../Model/Client_Section/meal_model.dart';

class ClientFavoritesController extends GetxController {
  final RxList<MealModel> favoriteMeals = <MealModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  void loadFavorites() {
    // In a real app, this would filter from a main list or fetch from API/Local Storage
    // For this UI demo, we will mock the data matching the image

    favoriteMeals.value = [
      MealModel(
        imageUrl:
            'https://images.unsplash.com/photo-1467003909585-2f8a7270028d?q=80&w=600', // Salmon Bowl
        title: "SALMON QUINOA POWER BOWL",
        time: "25m",
        servings: "1",
        calories: "520 cal",
        description:
            "A complete meal with lean protein, whole grains, and fresh vegetables, perfect for sustained energy and",
        isFavorite: true,
        tags: ["Lunch"],
        nutrition: {"Protein": "30g", "Carbs": "45g"},
        ingredients: {"Salmon": "150g", "Quinoa": "1 cup"},
        instructions: ["Cook quinoa", "Grill salmon", "Mix visuals"],
      ),
      MealModel(
        imageUrl:
            'https://images.unsplash.com/photo-1517620114540-4f6a4c43f8ed?q=80&w=600', // Oatmeal
        title: "BERRY OATMEAL BOWL",
        time: "10m",
        servings: "1",
        calories: "380 cal",
        description:
            "A warm, comforting breakfast bowl packed with whole grains, fresh berries, and heart-healthy nuts.",
        isFavorite: true,
        tags: ["Breakfast"],
        nutrition: {"Protein": "10g", "Fiber": "8g"},
        ingredients: {
          "Oats": "1/2 cup",
          "Berries": "Handful",
          "Nuts": "1 tbsp",
        },
        instructions: ["Cook oats", "Top with fruit"],
      ),
    ];
  }
}
