import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import 'forgot_password_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final ForgotPasswordController controller = Get.put(
    ForgotPasswordController(),
  );

  ForgotPasswordScreen({super.key});

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
                SizedBox(height: 180.h),

                // Card
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 32.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      24.r,
                    ), // Slightly tighter radius in image? Or same? sticking to 24-30
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
                        // Back Button
                        Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: controller.backToSignIn,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.arrow_back,
                                  size: 18.sp,
                                  color: const Color(0xFF6B7280),
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  "Back to Sign In",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12.sp,
                                    color: const Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 30.h),

                        // Icon Circle
                        Container(
                          width: 80.w,
                          height: 80.h,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFADADD), // Light pink circle
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.mail_outline,
                              size: 32.sp,
                              color:
                                  borderPink, // Using a specific color variable logic
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // Title
                        Text(
                          "FORGOT PASSWORD",
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 22.sp,
                            color: const Color(0xFFF09AB1),
                            fontWeight: FontWeight.w400, // Medium/Regular
                          ),
                        ),
                        SizedBox(height: 12.h),

                        // Subtitle
                        Text(
                          "Enter your email to receive a verification code",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                        SizedBox(height: 30.h),

                        // Email Field
                        Align(
                          alignment: Alignment.centerLeft,
                          child: _buildLabel("Email Address"),
                        ),
                        SizedBox(height: 8.h),
                        _buildTextField(
                          controller: controller.emailController,
                          hint: "your@email.com",
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || !GetUtils.isEmail(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 24.h),

                        // Send Button
                        SizedBox(
                          width: double.infinity,
                          height: 48.h,
                          child: Obx(
                            () => ElevatedButton(
                              onPressed: controller.isLoading.value
                                  ? null
                                  : controller.sendVerificationCode,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                  0xFFF09AB1,
                                ), // Pinkish color matching design
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
                                      "Send Verification Code",
                                      style: GoogleFonts.poppins(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // Security Note
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF9F5), // Light beige/pink
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.lock_outline,
                                size: 16.sp,
                                color: Colors.grey[600],
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: GoogleFonts.poppins(
                                      fontSize: 10.sp,
                                      color: Colors.grey[600],
                                      height: 1.5,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "Security Note: ",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const TextSpan(
                                        text:
                                            "We'll send a 6-digit verification code to your email address.",
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
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

  static const Color borderPink = Color(0xFFF09AB1);
  static const Color lightBorderPink = Color(0xFFFFE0E6);

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.playfairDisplay(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF4A4A4A),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
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
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 20.w, right: 12.w),
          child: Icon(icon, color: const Color(0xFF999CAD), size: 24.sp),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        contentPadding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 20.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
          borderSide: const BorderSide(color: lightBorderPink),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
          borderSide: const BorderSide(color: lightBorderPink),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
          borderSide: const BorderSide(color: borderPink),
        ),
        fillColor: const Color(0xFFFFFFF9),
        filled: true,
      ),
    );
  }
}
