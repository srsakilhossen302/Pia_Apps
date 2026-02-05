class ReproductiveStatusModel {
  String
  selectedStatus; // "None", "Perimenopause", "Menopause", "Pregnant", "Trying to Conceive"

  ReproductiveStatusModel({this.selectedStatus = "None"});

  Map<String, dynamic> toJson() {
    return {'selectedStatus': selectedStatus};
  }

  factory ReproductiveStatusModel.fromJson(Map<String, dynamic> json) {
    return ReproductiveStatusModel(
      selectedStatus: json['selectedStatus'] ?? "None",
    );
  }
}
