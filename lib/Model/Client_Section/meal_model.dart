class MealModel {
  final String imageUrl;
  final String title;
  final String time;
  final String servings;
  final String calories;
  final String description;
  final bool isFavorite;

  final List<String> tags;
  final String phaseBenefits;
  final Map<String, String> nutrition;
  final Map<String, String> ingredients;
  final List<String> instructions;

  MealModel({
    required this.imageUrl,
    required this.title,
    required this.time,
    required this.servings,
    required this.calories,
    required this.description,
    this.isFavorite = false,
    this.tags = const [],
    this.phaseBenefits = "",
    this.nutrition = const {},
    this.ingredients = const {},
    this.instructions = const [],
  });
}
