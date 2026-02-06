import 'package:get/get.dart';

class ClientCalendarController extends GetxController {
  // Mocking February 2026 as per design
  var focusedDate = DateTime(2026, 2, 23).obs;
  var selectedDate = DateTime(2026, 2, 23).obs;

  // Mock data for phases to match the image colors/dates
  // Menstrual: Feb 1-5
  // Follicular: Feb 6-12
  // Ovulation: Feb 13-16
  // Luteal: Feb 17-28

  // Helper list for month names
  final List<String> _monthNames = [
    "",
    "JANUARY",
    "FEBRUARY",
    "MARCH",
    "APRIL",
    "MAY",
    "JUNE",
    "JULY",
    "AUGUST",
    "SEPTEMBER",
    "OCTOBER",
    "NOVEMBER",
    "DECEMBER",
  ];

  String get currentMonthName {
    // Dynamically generate the month string based on focusedDate
    return "${_monthNames[focusedDate.value.month]} ${focusedDate.value.year}";
  }

  String get selectedDateSummary {
    return "${_monthNames[selectedDate.value.month]} ${selectedDate.value.day} SUMMARY";
  }

  void onDateSelected(DateTime date) {
    selectedDate.value = date;
  }

  void previousMonth() {
    // Navigate to previous month
    focusedDate.value = DateTime(
      focusedDate.value.year,
      focusedDate.value.month - 1,
      1,
    );
  }

  void nextMonth() {
    // Navigate to next month
    focusedDate.value = DateTime(
      focusedDate.value.year,
      focusedDate.value.month + 1,
      1,
    );
  }
}
