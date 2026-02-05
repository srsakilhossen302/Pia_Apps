import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Model/Client_Section/birthday_model.dart';
import 'health_conditions_screen.dart';
// import 'next_screen.dart';

class BirthdayController extends GetxController {
  final TextEditingController dateController =
      TextEditingController(); // For display

  // Model instance
  var birthdayModel = BirthdayModel().obs;

  void updateDate(DateTime date) {
    birthdayModel.update((val) {
      val?.dateOfBirth = date;
    });
    // Format date for display: MM/DD/YYYY
    dateController.text =
        "${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}";
  }

  void nextStep() {
    print("Next Step Data: ${birthdayModel.value.toJson()}");
    Get.snackbar("Success", "Birthday saved!");
    // Navigate to Step 5
    Get.to(() => HealthConditionsScreen());
  }

  void back() {
    Get.back();
  }

  void skip() {
    nextStep();
  }

  @override
  void onClose() {
    dateController.dispose();
    super.onClose();
  }
}
