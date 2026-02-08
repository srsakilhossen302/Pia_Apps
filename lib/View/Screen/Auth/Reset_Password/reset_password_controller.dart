import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Sign_In/sign_in_screen.dart';

class ResetPasswordController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  var isNewPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;
  var isLoading = false.obs;

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  Future<void> resetPassword() async {
    if (formKey.currentState!.validate()) {
      Get.focusScope?.unfocus(); // Unfocus to prevent render errors
      if (newPasswordController.text != confirmPasswordController.text) {
        Get.snackbar("Error", "Passwords do not match");
        return;
      }

      isLoading.value = true;
      try {
        // TODO: Implement Reset Password API logic here
        print(
          "Reset Password Logic: New Pass is ${newPasswordController.text}",
        );

        // Simulate API call
        await Future.delayed(const Duration(seconds: 2));

        Get.snackbar("Success", "Password reset successfully");

        // Navigate to Sign In
        Get.offAll(() => SignInScreen());
      } catch (e) {
        Get.snackbar("Error", "Something went wrong: $e");
      } finally {
        isLoading.value = false;
      }
    }
  }

  @override
  void onClose() {
    // newPasswordController.dispose();
    // confirmPasswordController.dispose();
    super.onClose();
  }
}
