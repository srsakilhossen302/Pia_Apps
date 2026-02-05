class PeriodInfoModel {
  DateTime? lastPeriodDate;
  String? trackingApp; // "Manual tracking" or other options
  int cycleLength; // e.g. 21 days

  PeriodInfoModel({
    this.lastPeriodDate,
    this.trackingApp,
    this.cycleLength = 28, // Default 28
  });

  Map<String, dynamic> toJson() {
    return {
      'lastPeriodDate': lastPeriodDate?.toIso8601String(),
      'trackingApp': trackingApp,
      'cycleLength': cycleLength,
    };
  }

  factory PeriodInfoModel.fromJson(Map<String, dynamic> json) {
    return PeriodInfoModel(
      lastPeriodDate: json['lastPeriodDate'] != null
          ? DateTime.parse(json['lastPeriodDate'])
          : null,
      trackingApp: json['trackingApp'],
      cycleLength: json['cycleLength'] ?? 28,
    );
  }
}
