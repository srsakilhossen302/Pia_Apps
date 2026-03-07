class CalendarResponse {
  final int? statusCode;
  final bool? success;
  final String? message;
  final CalendarData? data;

  CalendarResponse({this.statusCode, this.success, this.message, this.data});

  factory CalendarResponse.fromJson(Map<String, dynamic> json) {
    return CalendarResponse(
      statusCode: json['statusCode'],
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? CalendarData.fromJson(json['data']) : null,
    );
  }
}

class CalendarData {
  final String? month;
  final int? year;
  final List<CalendarDay>? days;

  CalendarData({this.month, this.year, this.days});

  factory CalendarData.fromJson(Map<String, dynamic> json) {
    return CalendarData(
      month: json['month'],
      year: json['year'],
      days: json['days'] != null
          ? List<CalendarDay>.from(
              json['days'].map((x) => CalendarDay.fromJson(x)),
            )
          : null,
    );
  }
}

class CalendarDay {
  final DateTime? date;
  final int? day;
  final int? cycleDay;
  final String? phase;
  final String? color;

  CalendarDay({this.date, this.day, this.cycleDay, this.phase, this.color});

  bool get isEmpty => date == null;

  factory CalendarDay.fromJson(Map<String, dynamic> json) {
    return CalendarDay(
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      day: json['day'],
      cycleDay: json['cycleDay'],
      phase: json['phase'],
      color: json['color'],
    );
  }
}
