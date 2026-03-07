import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'change_password_controller.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  final ChangePasswordController controller = Get.put(ChangePasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3F4), // Light pink background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.w),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back, color: Colors.black, size: 20.sp),
          ),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          "CHANGE PASSWORD",
          style: GoogleFonts.playfairDisplay(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Create New Password",
              style: GoogleFonts.playfairDisplay(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2D2D2D),
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              "Your new password must be different from previous used passwords.",
              style: GoogleFonts.lato(
                fontSize: 14.sp,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            SizedBox(height: 40.h),
            _buildPasswordField(
              "Current Password",
              "Enter current password",
              controller.currentPasswordController,
              controller.isCurrentPasswordVisible,
              controller.toggleCurrentPasswordVisibility,
            ),
            SizedBox(height: 20.h),
            _buildPasswordField(
              "New Password",
              "Enter new password",
              controller.newPasswordController,
              controller.isNewPasswordVisible,
              controller.toggleNewPasswordVisibility,
            ),
            SizedBox(height: 20.h),
            _buildPasswordField(
              "Confirm Password",
              "Confirm new password",
              controller.confirmPasswordController,
              controller.isConfirmPasswordVisible,
              controller.toggleConfirmPasswordVisibility,
            ),
            SizedBox(height: 40.h),
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 55.h,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.changePassword(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF48FB1),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "SAVE CHANGES",
                          style: GoogleFonts.lato(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 1.0,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    String label,
    String hint,
    TextEditingController textController,
    RxBool isVisible,
    VoidCallback toggleVisibility,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.lato(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D2D2D),
          ),
        ),
        SizedBox(height: 8.h),
        Obx(
          () => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: textController,
              obscureText: !isVisible.value,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.lato(
                  color: Colors.grey[400],
                  fontSize: 14.sp,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 18.h,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    isVisible.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.grey[400],
                  ),
                  onPressed: toggleVisibility,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
