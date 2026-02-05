class ExerciseLevelModel {
  String
  selectedLevel; // "Sedentary", "Light", "Moderate", "Active", "Very Active"

  ExerciseLevelModel({
    this.selectedLevel = "Moderate", // Default as per image or None
  });

  Map<String, dynamic> toJson() {
    return {'selectedLevel': selectedLevel};
  }

  factory ExerciseLevelModel.fromJson(Map<String, dynamic> json) {
    return ExerciseLevelModel(
      selectedLevel: json['selectedLevel'] ?? "Moderate",
    );
  }
}
