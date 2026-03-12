import 'package:flutter/material.dart';
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
  var rangeLabel = "".obs;
  var averageLabel = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchCycleMetadata();
  }

  Future<void> fetchCycleMetadata() async {
    try {
      final token = await SharePrefsHelper.getString(SharedPreferenceValue.token);
      final response = await GetConnect().get(
        "${ApiConstant.baseUrl}${ApiConstant.cycleMetadata}",
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = response.body['data'];
        if (data != null && data['cycleLength'] != null) {
          rangeLabel.value = data['cycleLength']['rangeLabel'] ?? "";
          averageLabel.value = data['cycleLength']['averageLabel'] ?? "";
          selectedDays.value = data['cycleLength']['defaultValue'] ?? 28;
        }
      }
    } catch (e) {
      debugPrint("Error fetching metadata: $e");
    }
  }

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
