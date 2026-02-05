import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Model/Client_Section/period_info_model.dart';
import 'reproductive_status_screen.dart';

class PeriodInfoController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController dateController = TextEditingController();

  var selectedTrackingOption = "Manual tracking".obs;
  List<String> trackingOptions = ["Manual tracking", "Flo", "Clue", "Other"];

  var cycleLength = 28.0.obs;

  // Model instance
  var periodInfo = PeriodInfoModel().obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize date controller if needed specific format
  }

  void updateDate(DateTime date) {
    periodInfo.update((val) {
      val?.lastPeriodDate = date;
    });
    // Format date for display: MM/DD/YYYY
    dateController.text =
        "${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}";
  }

  void updateTrackingOption(String? newValue) {
    if (newValue != null) {
      selectedTrackingOption.value = newValue;
      periodInfo.update((val) {
        val?.trackingApp = newValue;
      });
    }
  }

  void updateCycleLength(double value) {
    cycleLength.value = value;
    periodInfo.update((val) {
      val?.cycleLength = value.toInt();
    });
  }

  void nextStep() {
    print("Next Step Data: ${periodInfo.value.toJson()}");
    Get.snackbar("Success", "Period info saved!");
    // Navigate to next step
    Get.to(() => ReproductiveStatusScreen());
  }

  void skip() {
    print("Skipped Step 1");
    // Navigate to next step or home
  }

  @override
  void onClose() {
    dateController.dispose();
    super.onClose();
  }
}
