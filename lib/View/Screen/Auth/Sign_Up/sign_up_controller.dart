import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../helper/toast_helper.dart';
import '../../../../service/api_url.dart';
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
        ToastHelper.showError("Passwords do not match");
        return;
      }

      isLoading.value = true;
      update();

      try {
        final body = {
          "name": nameController.text.trim(),
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
          "role": "user",
        };

        final response = await GetConnect().post(
          "${ApiConstant.baseUrl}${ApiConstant.signUp}",
          body,
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          Get.to(
            () => VerifyCodeScreen(),
            arguments: {'email': emailController.text, 'source': 'sign_up'},
          );
          ToastHelper.showSuccess(
            response.body['message'] ?? "Registration successful!",
          );
        } else {
          String errorMsg = response.body['message'] ?? "Something went wrong";
          ToastHelper.showError(errorMsg);
        }
      } catch (e) {
        ToastHelper.showError("Network error. Please try again.");
      } finally {
        isLoading.value = false;
        update();
      }
    }
  }

  @override
  void onClose() {
    // nameController.dispose();
    // emailController.dispose();
    // passwordController.dispose();
    // confirmPasswordController.dispose();
    super.onClose();
  }
}
