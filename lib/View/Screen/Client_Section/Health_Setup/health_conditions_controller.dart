import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Model/Client_Section/health_conditions_model.dart';

class HealthConditionsController extends GetxController {
  final TextEditingController allergiesController = TextEditingController();
  final TextEditingController otherConditionsController =
      TextEditingController();

  // Observable list for checking multiple conditions
  var selectedConditions = <String>[].obs;

  final List<Map<String, String>> conditionsOptions = [
    {"code": "POTS", "name": "Postural Orthostatic Tachycardia Syndrome"},
    {"code": "IBS", "name": "Irritable Bowel Syndrome"},
    {"code": "PCOS", "name": "Polycystic Ovary Syndrome"},
  ];

  var healthConditions = HealthConditionsModel().obs;

  void toggleCondition(String code) {
    if (selectedConditions.contains(code)) {
      selectedConditions.remove(code);
    } else {
      selectedConditions.add(code);
    }
    updateModel();
  }

  void updateModel() {
    healthConditions.update((val) {
      val?.allergies = allergiesController.text;
      val?.otherConditions = otherConditionsController.text;
      val?.selectedConditions = selectedConditions;
    });
  }

  void completeSetup() {
    updateModel(); // Ensure latest text is captured
    print("Final Setup Data: ${healthConditions.value.toJson()}");
    Get.snackbar("Success", "Health setup completed!");

    // TODO: Navigate to Main Dashboard or Home
    // Get.offAll(() => MainHomeScreen());
  }

  void back() {
    Get.back();
  }

  void skip() {
    completeSetup();
  }

  @override
  void onClose() {
    allergiesController.dispose();
    otherConditionsController.dispose();
    super.onClose();
  }
}
