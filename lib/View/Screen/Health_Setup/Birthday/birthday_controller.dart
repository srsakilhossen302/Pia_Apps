import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../helper/shared_prefe/shared_prefe.dart';
import '../../../../helper/toast_helper.dart';
import '../../../../service/api_url.dart';
import '../../Client_Section/Home/client_home_screen.dart';
import '../Dietary_Restrictions/dietary_restrictions_screen.dart';

class BirthdayController extends GetxController {
  var selectedDate = DateTime.now().obs; // Default to now, or maybe 2000?
  var isLoading = false.obs;
  var dateText = "".obs;
  final TextEditingController dateController = TextEditingController();

  void onDateSelected(DateTime date) {
    selectedDate.value = date;
    // Format: MM/DD/YYYY
    String formattedDate =
        "${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}";
    dateController.text = formattedDate;
    dateText.value = formattedDate;
  }

  Future<void> completeSetup() async {
    isLoading.value = true;
    try {
      final token = await SharePrefsHelper.getString(SharedPreferenceValue.token);
      final body = {
        "dateOfBirth": selectedDate.value.toUtc().toIso8601String()
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
        ToastHelper.showSuccess("Birthday saved successfully");
        Get.to(() => DietaryRestrictionsScreen());
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
    Get.offAll(() => ClientHomeScreen());
  }

  @override
  void onClose() {
    dateController.dispose();
    super.onClose();
  }
}
