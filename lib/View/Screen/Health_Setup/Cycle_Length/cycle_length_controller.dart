import 'dart:convert';
import 'package:get/get.dart';
import '../../../../helper/shared_prefe/shared_prefe.dart';
import '../../../../helper/toast_helper.dart';
import '../../../../service/api_url.dart';
import '../../Client_Section/Home/client_home_screen.dart';
import '../../Health_Setup/Birthday/birthday_screen.dart';

class CycleLengthController extends GetxController {
  var selectedDays = 28.obs; // Default typically around 28 for cycles
  var isLoading = false.obs;

  // List of days from 1 to 31 (User requested 1-31, though cycles can be longer, I will stick to request)
  final List<int> days = List.generate(31, (index) => index + 1);

  void onDaysChanged(int index) {
    selectedDays.value = days[index];
  }

  Future<void> saveCycleLength() async {
    isLoading.value = true;
    try {
      final token = await SharePrefsHelper.getString(SharedPreferenceValue.token);
      final body = {
        "cycleLength": selectedDays.value
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
        ToastHelper.showSuccess("Cycle length saved successfully");
        Get.to(() => BirthdayScreen());
      } else {
        ToastHelper.showError(response.body?['message'] ?? "Failed to save data");
      }
    } catch (e) {
      ToastHelper.showError("Network error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void back() {
    Get.back();
  }

  void skip() {
    Get.offAll(() => const ClientHomeScreen());
  }
}
