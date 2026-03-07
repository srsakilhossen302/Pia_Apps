import 'package:get/get.dart';
import '../../../../Model/Client_Section/calendar_model.dart';
import '../../../../Model/Client_Section/cycle_overview_model.dart';
import '../../../../Model/Client_Section/phase_detail_model.dart';
import '../../../../helper/shared_prefe/shared_prefe.dart';
import '../../../../helper/toast_helper.dart';
import '../../../../service/api_url.dart';

class ClientCalendarController extends GetxController {
  var isLoading = false.obs;
  var isPhaseLoading = false.obs;
  
  var calendarData = Rxn<CalendarData>();
  var phaseData = Rxn<CurrentPhaseInfo>();
  
  var focusedDate = DateTime.now().obs;
  // Initialize to clean local date
  var selectedDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).obs;

  @override
  void onInit() {
    super.onInit();
    // Ensure selected date is fresh today on init
    final now = DateTime.now();
    selectedDate.value = DateTime(now.year, now.month, now.day);
    refreshData();
  }

  Future<void> refreshData() async {
    await getCalendarData();
    await getPhaseForDate(selectedDate.value);
  }

  // Phase 1: Get Calendar Grid Data
  Future<void> getCalendarData() async {
    isLoading.value = true;
    try {
      final token = await SharePrefsHelper.getString(SharedPreferenceValue.token);
      final url = "${ApiConstant.baseUrl}${ApiConstant.cycleCalendar}";

      final response = await GetConnect().get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final calendarResponse = CalendarResponse.fromJson(response.body);
        calendarData.value = calendarResponse.data;
        
        // Update focused date based on API month/year
        if (calendarData.value?.month != null && calendarData.value?.year != null) {
          int monthIdx = _monthNames.indexWhere(
            (m) => m.toUpperCase() == calendarData.value!.month!.toUpperCase()
          );
          if (monthIdx != -1) {
            focusedDate.value = DateTime(calendarData.value!.year!, monthIdx, 1);
          }
        }
      }
    } catch (e) {
      ToastHelper.showError("Calendar Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Phase 2: Get Phase Detail for Selected Date
  Future<void> getPhaseForDate(DateTime date) async {
    isPhaseLoading.value = true;
    try {
      final token = await SharePrefsHelper.getString(SharedPreferenceValue.token);
      
      // Format as d-MM-yyyy (e.g. 3-03-2026)
      final dayStr = date.day;
      final monthStr = date.month.toString().padLeft(2, '0');
      final yearStr = date.year;
      final formattedDate = "$dayStr-$monthStr-$yearStr";

      final url = "${ApiConstant.baseUrl}${ApiConstant.cyclePhase}?date=$formattedDate";

      final response = await GetConnect().get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final phaseResponse = PhaseDetailResponse.fromJson(response.body);
        phaseData.value = phaseResponse.data;
      }
    } catch (e) {
      // Silent error
    } finally {
      isPhaseLoading.value = false;
    }
  }

  void onDateSelected(int year, int month, int day) {
    // Construct local date to avoid any UTC shift from API data
    selectedDate.value = DateTime(year, month, day);
    getPhaseForDate(selectedDate.value);
  }

  final List<String> _monthNames = [
    "", "JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE", 
    "JULY", "AUGUST", "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER"
  ];

  String get currentMonthLabel => "${calendarData.value?.month ?? ""} ${calendarData.value?.year ?? ""}".toUpperCase();
  
  String get selectedDateSummaryLabel {
    // Use the month name from API data to ensure consistency with header
    String monthName = calendarData.value?.month ?? _monthNames[selectedDate.value.month];
    return "${monthName.toUpperCase()} ${selectedDate.value.day} SUMMARY";
  }

  int get apiYear => calendarData.value?.year ?? focusedDate.value.year;
  
  int get apiMonthIndex {
    if (calendarData.value?.month == null) return focusedDate.value.month;
    int idx = _monthNames.indexWhere((m) => m.toUpperCase() == calendarData.value!.month!.toUpperCase());
    return idx != -1 ? idx : focusedDate.value.month;
  }

  CalendarDay? get selectedDayCalendarInfo {
    if (calendarData.value?.days == null) return null;
    return calendarData.value!.days!.firstWhere(
      (d) => d.day == selectedDate.value.day,
      orElse: () => CalendarDay(),
    );
  }
}
