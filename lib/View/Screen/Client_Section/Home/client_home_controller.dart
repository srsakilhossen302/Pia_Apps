import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:pia/Model/Client_Section/meal_model.dart';
import 'package:pia/Utils/AppIcons/app_icons.dart';

class ClientPhaseModel {
  final String title;
  final String description;
  final String icon;
  final Color backgroundColor;

  ClientPhaseModel({
    required this.title,
    required this.description,
    required this.icon,
    required this.backgroundColor,
  });
}

class ClientHomeController extends GetxController {
  final RxInt currentIndex = 0.obs;
  // Flag to toggle between Complete (New Design) and Incomplete (Old Design) views
  final RxBool isProfileComplete = false.obs;
  late PageController pageController;

  final List<ClientPhaseModel> phases = [
    ClientPhaseModel(
      title: "LUTEAL",
      description:
          "Manage mood and energy with complex carbs, magnesium, and B vitamins to ease PMS symptoms.",
      icon: AppIcons.LUTEAL,
      backgroundColor: const Color(0xFFFADADF), // Light pink
    ),
    ClientPhaseModel(
      title: "MENSTRUAL",
      description:
          "Focus on iron-rich foods and anti-inflammatory nutrients to support your body during menstruation.",
      icon: AppIcons.MENSTRUAL,
      backgroundColor: const Color(0xFFFADADF), // Dusky taupe/pink
    ),
    ClientPhaseModel(
      title: "FOLLICULAR",
      description:
          "Boost energy with fresh vegetables, lean proteins, and foods that support estrogen production.",
      icon: AppIcons.FOLLICULAR,
      backgroundColor: const Color(0xFFFADADF), // Slightly different shade
    ),
    ClientPhaseModel(
      title: "OVULATION",
      description:
          "Support fertility with antioxidant-rich foods, fiber, and anti-inflammatory omega-3s.",
      icon: AppIcons.OVULATION,
      backgroundColor: const Color(0xFFFADADF), // Another soft shade
    ),
  ];

  final RxList<MealModel> meals = <MealModel>[
    MealModel(
      imageUrl:
          'https://images.unsplash.com/photo-1517673132405-a56a62b18caf?q=80&w=600',
      title: "BERRY OATMEAL BOWL",
      time: "10m",
      servings: "1",
      calories: "380 cal",
      description:
          "A warm, comforting breakfast bowl packed with whole grains, fresh berries, and heart-healthy nuts.",
      tags: ["Breakfast", "Fiber Rich"],
      phaseBenefits:
          "Oats provide slow-releasing energy while berries offer antioxidants to combat inflammation.",
      nutrition: {
        "Protein": "12g",
        "Carbs": "64g",
        "Fat": "10g",
        "Fiber": "8g",
      },
      ingredients: {
        "Rolled Oats": "1 cup",
        "Almond Milk": "1.5 cups",
        "Mixed Berries": "1/2 cup",
        "Chia Seeds": "1 tbsp",
        "Honey": "1 tsp",
      },
      instructions: [
        "Combine oats and almond milk in a pot.",
        "Simmer on medium heat for 10 minutes.",
        "Stir in chia seeds and honey.",
        "Top with fresh berries and serve.",
      ],
    ),
    MealModel(
      imageUrl:
          'https://images.unsplash.com/photo-1467003909585-2f8a7270028d?q=80&w=600', // Salmon image
      title: "SALMON QUINOA POWER BOWL",
      time: "25m",
      servings: "1",
      calories: "520 cal",
      description:
          "A complete meal with lean protein, whole grains, and fresh vegetables, perfect for sustained energy and hormone balance.",
      isFavorite: true,
      tags: ["Ovulation", "Luteal"],
      phaseBenefits:
          "Omega-3s support anti-inflammatory response during ovulation. High protein aids muscle repair. Fiber helps eliminate excess estrogen during luteal phase.",
      nutrition: {
        "Protein": "38g",
        "Carbs": "48g",
        "Fat": "18g",
        "Fiber": "10g",
        "Iron": "4.2mg",
        "Calcium": "120mg",
        "Vitamin C": "25mg",
        "Vitamin D": "15mg",
        "Omega-3": "2.8mg",
        "Magnesium": "95mg",
      },
      ingredients: {
        "Salmon fillet": "150 g",
        "Quinoa": "1 cup",
        "Spinach": "2 cups",
        "Cucumber": "1 whole",
        "Edamame": "0.5 cup",
        "Lemon": "1 whole",
        "Tahini": "2 tbsp",
      },
      instructions: [
        "Cook quinoa according to package instructions.",
        "Season salmon with salt, pepper, and lemon juice.",
        "Bake salmon at 400°F for 12-15 minutes.",
        "Prepare vegetables: slice cucumber, wash spinach.",
        "Cook edamame according to package directions.",
        "Arrange quinoa, salmon, and vegetables in a bowl.",
        "Drizzle with tahini dressing and serve.",
      ],
    ),
    MealModel(
      imageUrl:
          'https://images.unsplash.com/photo-1493770348161-369560ae357d?q=80&w=600',
      title: "MIXED NUTS TRAIL MIX",
      time: "5m",
      servings: "4",
      calories: "220 cal",
      description:
          "A convenient, nutrient-dense snack combining nuts, seeds, and a touch of sweetness for sustained energy.",
      tags: ["Snack", "Energy"],
      phaseBenefits: "Healthy fats from nuts support hormone production.",
      nutrition: {"Protein": "6g", "Fat": "16g"},
      ingredients: {
        "Almonds": "1/2 cup",
        "Walnuts": "1/2 cup",
        "Dried Cranberries": "1/4 cup",
      },
      instructions: [
        "Mix all ingredients in a bowl.",
        "Store in an airtight container.",
      ],
    ),
    MealModel(
      imageUrl:
          'https://images.unsplash.com/photo-1590080875515-8a3a8dc5735e?q=80&w=600', // Dark Chocolate Energy Bites
      title: "DARK CHOCOLATE ENERGY BITES",
      time: "15m",
      servings: "6",
      calories: "180 cal",
      description:
          "Indulgent yet nutritious chocolate treats that satisfy sweet cravings while providing essential minerals.",
      tags: ["Dessert", "Antioxidants"],
      phaseBenefits:
          "Dark chocolate is rich in magnesium which helps alleviate cramps.",
      nutrition: {"Protein": "4g", "Sugar": "8g"},
      ingredients: {
        "Dates": "10",
        "Cocoa Powder": "2 tbsp",
        "Almonds": "1/2 cup",
      },
      instructions: [
        "Blend dates and almonds in a food processor.",
        "Add cocoa powder and blend until sticky.",
        "Roll into balls and refrigerate.",
      ],
    ),
  ].obs;

  void toggleFavorite(int index) {
    var meal = meals[index];
    meals[index] = MealModel(
      imageUrl: meal.imageUrl,
      title: meal.title,
      time: meal.time,
      servings: meal.servings,
      calories: meal.calories,
      description: meal.description,
      isFavorite: !meal.isFavorite,
    );
  }

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(viewportFraction: 1.0);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  void nextPage() {
    if (currentIndex.value < phases.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (currentIndex.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      pageController.animateToPage(
        phases.length - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
