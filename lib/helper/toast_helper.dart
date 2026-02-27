import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ToastHelper {
  static void showSuccess(String message) {
    Get.rawSnackbar(
      message: message,
      backgroundColor: Colors.green.withOpacity(0.8),
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.all(15.w),
      borderRadius: 10.r,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }

  static void showError(String message) {
    Get.rawSnackbar(
      message: message,
      backgroundColor: Colors.redAccent.withOpacity(0.8),
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.all(15.w),
      borderRadius: 10.r,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.error, color: Colors.white),
    );
  }

  static void showMessage(String message) {
    Get.rawSnackbar(
      message: message,
      backgroundColor: const Color(0xFF333333).withOpacity(0.8),
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.all(15.w),
      borderRadius: 10.r,
      duration: const Duration(seconds: 3),
    );
  }
}
