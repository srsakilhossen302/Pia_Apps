import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientEditProfileController extends GetxController {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController birthdayController;

  @override
  void onInit() {
    super.onInit();
    // Initialize with mock data matching the image or passed arguments
    nameController = TextEditingController(text: "Elena Gilbert");
    emailController = TextEditingController(text: "elena.g@cyclecare.com");
    birthdayController = TextEditingController(text: "");
  }

  void saveChanges() {
    // Implement save logic here
    Get.back();
    Get.snackbar("Success", "Profile updated successfully");
  }

  void cancel() {
    Get.back();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    birthdayController.dispose();
    super.onClose();
  }
}
