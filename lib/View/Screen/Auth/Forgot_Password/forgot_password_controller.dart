import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../helper/toast_helper.dart';
import '../../../../service/api_url.dart';
import '../Verify_Code/verify_code_screen.dart';

class ForgotPasswordController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  var isLoading = false.obs;

  Future<void> sendVerificationCode() async {
    if (formKey.currentState!.validate()) {
      Get.focusScope?.unfocus();
      isLoading.value = true;
      update();
      try {
        final body = {"email": emailController.text.trim()};

        final response = await GetConnect().post(
          "${ApiConstant.baseUrl}${ApiConstant.forgetPassword}",
          body,
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          ToastHelper.showSuccess(
            response.body['message'] ?? "Verification code sent to your email",
          );

          Get.to(
            () => VerifyCodeScreen(),
            arguments: {
              'email': emailController.text.trim(),
              'source': 'forgot_password',
            },
          );
        } else {
          String errorMsg = response.body['message'] ?? "Failed to send code";
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

  void backToSignIn() {
    Get.back();
  }

  @override
  void onClose() {
    // emailController.dispose();
    super.onClose();
  }
}
