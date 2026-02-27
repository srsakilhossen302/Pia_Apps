import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../helper/shared_prefe/shared_prefe.dart';
import '../../../../helper/toast_helper.dart';
import '../../../../service/api_url.dart';
import '../../Client_Section/Home/client_home_screen.dart';
import '../Forgot_Password/forgot_password_screen.dart';

class SignInController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var isPasswordVisible = false.obs;
  var isRememberMe = false.obs;
  var isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleRememberMe() {
    isRememberMe.value = !isRememberMe.value;
  }

  Future<void> signIn() async {
    if (formKey.currentState!.validate()) {
      Get.focusScope?.unfocus();

      isLoading.value = true;
      update();

      try {
        final body = {
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
          "rememberMe": isRememberMe.value,
        };

        final response = await GetConnect().post(
          "${ApiConstant.baseUrl}${ApiConstant.login}",
          body,
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          final data = response.body['data'];
          final accessToken = data['accessToken'];

          // Save token
          await SharePrefsHelper.setString(
            SharedPreferenceValue.token,
            accessToken,
          );

          ToastHelper.showSuccess(
            response.body['message'] ?? "Logged in successfully",
          );
          Get.offAll(() => ClientHomeScreen());
        } else {
          String errorMsg = response.body['message'] ?? "Login failed";
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

  void forgotPassword() {
    // Navigate to Forgot Password Screen
    Get.to(() => ForgotPasswordScreen());
  }

  @override
  void onClose() {
    // emailController.dispose();
    // passwordController.dispose();
    super.onClose();
  }
}
