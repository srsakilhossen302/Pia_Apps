import 'dart:convert';
import 'package:get/get.dart';
import '../../../../helper/shared_prefe/shared_prefe.dart';
import '../../../../helper/toast_helper.dart';
import '../../../../service/api_url.dart';
import '../../Client_Section/Home/client_home_screen.dart';
import '../Period_Length/period_length_screen.dart';

class PeriodStartController extends GetxController {
  var selectedDate = DateTime.now().obs;
  var isLoading = false.obs;

  void onDateSelected(DateTime date) {
    selectedDate.value = date;
  }

  Future<void> savePeriodStart() async {
    isLoading.value = true;
    try {
      final token = await SharePrefsHelper.getString(SharedPreferenceValue.token);
      final body = {
        "lastPeriodStartDate": selectedDate.value.toUtc().toIso8601String()
      };
      
      final formData = FormData({
        "data": jsonEncode(body)
      });
      
      final response = await GetConnect().patch(
        "${ApiConstant.baseUrl}${ApiConstant.userProfile}",
        formData,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ToastHelper.showSuccess("Information saved successfully");
        Get.to(() => PeriodLengthScreen());
      } else {
        ToastHelper.showError(response.body?['message'] ?? "Failed to save data");
      }
    } catch (e) {
      ToastHelper.showError("Network error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void skip() {
    Get.offAll(() => const ClientHomeScreen());
  }
}
