import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Client_Section/Home/client_home_screen.dart';
import '../Dietary_Restrictions/dietary_restrictions_screen.dart';

class BirthdayController extends GetxController {
  var selectedDate = DateTime.now().obs; // Default to now, or maybe 2000?
  var isLoading = false.obs;
  var dateText = "".obs;
  final TextEditingController dateController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Default empty or set? Image shows MM/DD/YYYY placeholder.
    // dateController.text = "";
  }

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
      // TODO: Implement POST API to save birthday and complete setup
      print("Saving Birthday: ${dateController.text}");

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      Get.snackbar("Success", "Setup completed successfully!");

      // Navigate to Dietary Restrictions Screen
      Get.to(() => DietaryRestrictionsScreen());
    } catch (e) {
      Get.snackbar("Error", "Failed to save data");
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
