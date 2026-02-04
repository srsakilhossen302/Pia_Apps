import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  var isLoading = false.obs;

  Future<void> sendVerificationCode() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      try {
        // TODO: Implement Forgot Password API logic here
        print("Forgot Password Logic: Email: ${emailController.text}");

        // Simulate API call
        await Future.delayed(const Duration(seconds: 2));

        Get.snackbar(
          "Success",
          "Verification code sent to ${emailController.text}",
        );

        // Navigate to OTP Screen (to be implemented later)
      } catch (e) {
        Get.snackbar("Error", "Something went wrong: $e");
      } finally {
        isLoading.value = false;
      }
    }
  }

  void backToSignIn() {
    Get.back();
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
