import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../helper/shared_prefe/shared_prefe.dart';
import '../../../../../helper/toast_helper.dart';
import '../../../../../service/api_url.dart';

class ChangePasswordController extends GetxController {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  var isCurrentPasswordVisible = false.obs;
  var isNewPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;
  var isLoading = false.obs;

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void toggleCurrentPasswordVisibility() {
    isCurrentPasswordVisible.value = !isCurrentPasswordVisible.value;
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }
  
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  Future<void> changePassword() async {
    final currentPassword = currentPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (currentPassword.isEmpty) {
      ToastHelper.showError("Please enter your current password");
      return;
    }
    if (newPassword.isEmpty) {
      ToastHelper.showError("Please enter your new password");
      return;
    }
    if (newPassword.length < 8) {
      ToastHelper.showError("New password must be at least 8 characters");
      return;
    }
    if (confirmPassword.isEmpty) {
      ToastHelper.showError("Please confirm your new password");
      return;
    }
    if (newPassword != confirmPassword) {
      ToastHelper.showError("Passwords do not match");
      return;
    }

    isLoading.value = true;
    update();
    try {
      final token = await SharePrefsHelper.getString(SharedPreferenceValue.token);

      final response = await GetConnect().post(
        "${ApiConstant.baseUrl}${ApiConstant.changePassword}",
        {
          "currentPassword": currentPassword,
          "newPassword": newPassword,
          "confirmPassword": confirmPassword,
        },
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ToastHelper.showSuccess("Password changed successfully");
        Get.back();
      } else {
        ToastHelper.showError(
          response.body['message'] ?? "Failed to change password",
        );
      }
    } catch (e) {
      ToastHelper.showError("Network error: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
