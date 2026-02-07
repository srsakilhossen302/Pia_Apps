import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pia/Utils/AppColors/app_colors.dart';
import 'package:pia/Utils/AppIcons/app_icons.dart';
import 'period_start_controller.dart';

class PeriodStartScreen extends StatelessWidget {
  final PeriodStartController controller = Get.put(PeriodStartController());

  PeriodStartScreen({super.key});

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
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 10.h),
              // Header with Title and Skip
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "HEALTH SETUP",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 20.sp,
                        color: const Color(0xFFF09AB1), // Pink color
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.skip,
                      child: Text(
                        "Skip",
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          color: const Color(0xFF6B7280),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              // Progress Bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  children: [
                    // Step 1 - Filled Pink
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF09AB1),
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                    ),
                    // Remaining Steps - Light Background
                    Expanded(
                      flex: 3,
                      child: Container(
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Step 1 of 4",
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30.h),

              // Icon Circle
              Container(
                width: 80.w,
                height: 80.h,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    AppIcons.pERIODINFO, // Using AppIcons
                    width: 40.w,
                    height: 40.h,
                    color: const Color(0xFFF09AB1),
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // Main Question
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Text(
                  "WHEN DID YOUR LAST\nPERIOD START?",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 24.sp,
                    color: const Color(0xFFF09AB1),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 12.h),

              // Subtitle
              Text(
                "We use it to determine the phase you're in",
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  color: const Color(0xFF6B7280),
                ),
              ),

              SizedBox(height: 30.h),

              // Calendar Card
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 24.w),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Theme(
                    data: ThemeData.light().copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Color(0xFFF09AB1), // Pink selection
                        onPrimary: Colors.white,
                        onSurface: Colors.black87,
                      ),
                      dialogBackgroundColor: Colors.white,
                    ),
                    child: Obx(
                      () => CalendarDatePicker(
                        initialDate: controller.selectedDate.value,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                        onDateChanged: controller.onDateSelected,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30.h),

              // Continue Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: Obx(
                    () => ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.savePeriodStart,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF09AB1),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        elevation: 5,
                        shadowColor: const Color(0xFFF09AB1).withOpacity(0.4),
                      ),
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Continue",
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Icon(Icons.arrow_forward_ios, size: 16.sp),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
