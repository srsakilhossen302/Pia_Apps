import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../helper/shared_prefe/shared_prefe.dart';
import '../../../../helper/toast_helper.dart';
import '../../../../service/api_url.dart';
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
      Get.focusScope?.unfocus();
      if (newPasswordController.text != confirmPasswordController.text) {
        ToastHelper.showError("Passwords do not match");
        return;
      }

      isLoading.value = true;
      update();
      try {
        final token = await SharePrefsHelper.getString(
          SharedPreferenceValue.token,
        );

        final body = {
          "newPassword": newPasswordController.text.trim(),
          "confirmPassword": confirmPasswordController.text.trim(),
        };

        print(
          "Reset Password URL: ${ApiConstant.baseUrl}${ApiConstant.resetPassword}",
        );
        print("Reset Password Request Body: $body");
        print("Reset Password Token: $token");

        final response = await GetConnect().post(
          "${ApiConstant.baseUrl}${ApiConstant.resetPassword}",
          body,
          headers: {'Authorization': token},
        );

        print("Response Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");

        if (response.statusCode == 200 || response.statusCode == 201) {
          ToastHelper.showSuccess(
            response.body['message'] ?? "Password reset successfully!",
          );
          Get.offAll(() => SignInScreen());
        } else {
          String errorMsg =
              response.body['message'] ?? "Failed to reset password";
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
    // newPasswordController.dispose();
    // confirmPasswordController.dispose();
    super.onClose();
  }
}
