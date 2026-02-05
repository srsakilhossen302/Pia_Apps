import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Verify_Code/verify_code_screen.dart';

class SignUpController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  var isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  Future<void> signUp() async {
    if (formKey.currentState!.validate()) {
      if (passwordController.text != confirmPasswordController.text) {
        Get.snackbar("Error", "Passwords do not match");
        return;
      }

      isLoading.value = true;
      try {
        // TODO: Implement Post API logic here
        print(
          "SignUp Logic: Name: ${nameController.text}, Email: ${emailController.text}",
        );

        // Simulate API call
        await Future.delayed(const Duration(seconds: 2));

        // Navigate to VerifyCodeScreen with email
        Get.to(
          () => VerifyCodeScreen(),
          arguments: {'email': emailController.text},
        );
        Get.snackbar(
          "Success",
          "Account created successfully. Please verify your email.",
        );
      } catch (e) {
        Get.snackbar("Error", "Something went wrong: $e");
      } finally {
        isLoading.value = false;
      }
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
