import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pia/View/Screen/Client_Section/Health_Setup/period_info_screen.dart';
import '../Forgot_Password/forgot_password_screen.dart';

class SignInController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var isPasswordVisible = false.obs;
  var isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> signIn() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      try {
        // TODO: Implement Login API logic here
        print("SignIn Logic: Email: ${emailController.text}");

        // Simulate API call
        await Future.delayed(const Duration(seconds: 2));

        // Navigate to Home
        Get.to(() => PeriodInfoScreen());
        Get.snackbar("Success", "Logged in successfully");
      } catch (e) {
        Get.snackbar("Error", "Something went wrong: $e");
      } finally {
        isLoading.value = false;
      }
    }
  }

  void forgotPassword() {
    // Navigate to Forgot Password Screen
    Get.to(() => ForgotPasswordScreen());
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
