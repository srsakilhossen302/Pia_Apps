import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pia/Utils/AppIcons/app_icons.dart';
import '../../../../Utils/AppColors/app_colors.dart';

import 'reset_password_controller.dart';

class ResetPasswordScreen extends StatelessWidget {
  final ResetPasswordController controller = Get.put(ResetPasswordController());

  ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.splashColor1, AppColors.splashColor2],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                SizedBox(height: 150.h),

                // Card
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 32.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFF09AB1).withOpacity(0.15),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        // Icon Circle
                        Container(
                          width: 80.w,
                          height: 80.h,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFADADD), // Light pink circle
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Image.asset(
                              AppIcons.passwordsIconsR,
                              color: const Color(0xFFF09AB1),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // Title
                        Text(
                          "NEW PASSWORD",
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 22.sp,
                            color: const Color(0xFFF09AB1),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 12.h),

                        // Subtitle
                        Text(
                          "Create a strong password for your account",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                        SizedBox(height: 30.h),

                        // New Password Field
                        Align(
                          alignment: Alignment.centerLeft,
                          child: _buildLabel("New Password"),
                        ),
                        SizedBox(height: 8.h),
                        Obx(
                          () => _buildTextField(
                            controller: controller.newPasswordController,
                            hint: "At least 6 characters",
                            isObscure: !controller.isNewPasswordVisible.value,
                            isPassword: true,
                            onToggleVisibility:
                                controller.toggleNewPasswordVisibility,
                            validator: (value) {
                              if (value == null || value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Confirm Password Field
                        Align(
                          alignment: Alignment.centerLeft,
                          child: _buildLabel("Confirm New Password"),
                        ),
                        SizedBox(height: 8.h),
                        Obx(
                          () => _buildTextField(
                            controller: controller.confirmPasswordController,
                            hint: "Re-enter password",
                            isObscure:
                                !controller.isConfirmPasswordVisible.value,
                            isPassword: true,
                            onToggleVisibility:
                                controller.toggleConfirmPasswordVisibility,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // Password Requirements
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF9F5), // Light beige/pink
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Password Requirements:",
                                style: GoogleFonts.poppins(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF4A4A4A),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                "• At least 6 characters",
                                style: GoogleFonts.poppins(
                                  fontSize: 11.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                "• Passwords match",
                                style: GoogleFonts.poppins(
                                  fontSize: 11.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // Reset Button
                        SizedBox(
                          width: double.infinity,
                          height: 48.h,
                          child: Obx(
                            () => ElevatedButton(
                              onPressed: controller.isLoading.value
                                  ? null
                                  : () {
                                      controller.resetPassword();
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF09AB1),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                elevation: 0,
                              ),
                              child: controller.isLoading.value
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      "Reset Password",
                                      style: GoogleFonts.poppins(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Row(
      children: [
        Image.asset(AppIcons.passwordsIconsL, color: const Color(0xFF4A4A4A)),
        SizedBox(width: 8.w),
        Text(
          label,
          style: GoogleFonts.playfairDisplay(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF4A4A4A),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
    bool isObscure = false,
    VoidCallback? onToggleVisibility,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      validator: validator,
      style: GoogleFonts.playfairDisplay(
        fontSize: 16.sp,
        color: const Color(0xFF2D3142),
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.playfairDisplay(
          color: const Color(0xFF9CA3AF),
          fontSize: 16.sp,
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isObscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: Colors.grey[400],
                  size: 20.sp,
                ),
                onPressed: onToggleVisibility,
              )
            : null,
        contentPadding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 20.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
          borderSide: const BorderSide(color: Color(0xFFFFE0E6)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
          borderSide: const BorderSide(color: Color(0xFFFFE0E6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
          borderSide: const BorderSide(color: Color(0xFFF09AB1)),
        ),
        fillColor: const Color(0xFFFFFFF9),
        filled: true,
      ),
    );
  }
}
