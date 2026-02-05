import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import 'verify_code_controller.dart';

class VerifyCodeScreen extends StatelessWidget {
  final VerifyCodeController controller = Get.put(VerifyCodeController());

  VerifyCodeScreen({super.key});

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
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFF09AB1).withOpacity(0.15),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Back Button
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            Get.back();
                          },
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
                                "Back",
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
                            color: const Color(0xFFF09AB1),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Title
                      Text(
                        "VERIFY CODE",
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 22.sp,
                          color: const Color(0xFFF09AB1),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 12.h),

                      // Subtitle
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: "Enter the 6-digit code sent to\n",
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            color: const Color(0xFF6B7280),
                            height: 1.5,
                          ),
                          children: [
                            TextSpan(
                              text: controller.email,
                              style: GoogleFonts.poppins(
                                color: const Color(0xFFF09AB1),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30.h),

                      // OTP Fields
                      PinCodeTextField(
                        appContext: context,
                        length: 6,
                        obscureText: false,
                        animationType: AnimationType.fade,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(12.r),
                          fieldHeight: 48.w,
                          fieldWidth: 44.w,
                          activeFillColor: const Color(0xFFFFF8F6),
                          inactiveFillColor: const Color(0xFFFFF8F6),
                          selectedFillColor: const Color(0xFFFFF8F6),
                          activeColor: const Color(
                            0xFFF09AB1,
                          ), // Pink border when active
                          inactiveColor: const Color(
                            0xFFFFE0E6,
                          ), // Light pink border when inactive
                          selectedColor: const Color(0xFFF09AB1),
                          borderWidth: 1,
                        ),
                        animationDuration: const Duration(milliseconds: 300),
                        backgroundColor: Colors.transparent,
                        enableActiveFill: true,
                        keyboardType: TextInputType.number,
                        textStyle: GoogleFonts.poppins(
                          fontSize: 18.sp,
                          color: const Color(0xFFF09AB1),
                          fontWeight: FontWeight.w600,
                        ),
                        onChanged: (value) {
                          controller.otp.value = value;
                        },
                        beforeTextPaste: (text) {
                          return true;
                        },
                      ),

                      SizedBox(height: 24.h),

                      // Verify Button
                      SizedBox(
                        width: double.infinity,
                        height: 48.h,
                        child: Obx(
                          () => ElevatedButton(
                            onPressed: controller.isLoading.value
                                ? null
                                : controller.verifyCode,
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
                                    "Verify Code",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // Resend Timer
                      Obx(() {
                        if (controller.timerValue.value > 0) {
                          return Text(
                            "Resend code in ${controller.timerValue.value}s",
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF6B7280),
                              fontSize: 12.sp,
                            ),
                          );
                        } else {
                          return GestureDetector(
                            onTap: controller.resendCode,
                            child: Text(
                              "Resend Code",
                              style: GoogleFonts.poppins(
                                color: const Color(0xFFF09AB1),
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor: const Color(0xFFF09AB1),
                              ),
                            ),
                          );
                        }
                      }),

                      SizedBox(height: 24.h),

                      // Info Note
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF9F5), // Light beige/pink
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.mail_outline,
                                  size: 14.sp,
                                  color: Colors.grey[600],
                                ), // Used mail_outline as approximation for the icon in image
                                SizedBox(width: 8.w),
                                Text(
                                  "Didn't receive the code?",
                                  style: GoogleFonts.poppins(
                                    fontSize: 11.sp,
                                    color: const Color(0xFF1F1F1F),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              "• Check your spam or junk folder",
                              style: GoogleFonts.poppins(
                                fontSize: 10.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              "• Wait a few moments and check again",
                              style: GoogleFonts.poppins(
                                fontSize: 10.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                            GestureDetector(
                              onTap: controller.resendCode,
                              child: Text(
                                "• Click \"Resend\" after timer expires",
                                style: GoogleFonts.poppins(
                                  fontSize: 10.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
