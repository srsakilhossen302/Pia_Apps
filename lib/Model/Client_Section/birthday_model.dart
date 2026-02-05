class BirthdayModel {
  DateTime? dateOfBirth;

  BirthdayModel({this.dateOfBirth});

  Map<String, dynamic> toJson() {
    return {'dateOfBirth': dateOfBirth?.toIso8601String()};
  }

  factory BirthdayModel.fromJson(Map<String, dynamic> json) {
    return BirthdayModel(
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
    );
  }
}
