class HealthConditionsModel {
  String? allergies;
  List<String> selectedConditions; // ["POTS", "IBS", "PCOS"]
  String? otherConditions;

  HealthConditionsModel({
    this.allergies,
    this.selectedConditions = const [],
    this.otherConditions,
  });

  Map<String, dynamic> toJson() {
    return {
      'allergies': allergies,
      'selectedConditions': selectedConditions,
      'otherConditions': otherConditions,
    };
  }

  factory HealthConditionsModel.fromJson(Map<String, dynamic> json) {
    return HealthConditionsModel(
      allergies: json['allergies'],
      selectedConditions: List<String>.from(json['selectedConditions'] ?? []),
      otherConditions: json['otherConditions'],
    );
  }
}
