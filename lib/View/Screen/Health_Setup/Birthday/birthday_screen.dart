import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pia/Utils/AppIcons/app_icons.dart';
import 'package:pia/Utils/AppColors/app_colors.dart';
import 'birthday_controller.dart';

class BirthdayScreen extends StatelessWidget {
  final BirthdayController controller = Get.put(BirthdayController());

  BirthdayScreen({super.key});

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
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10.h),
                // Header
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

                // Progress Bar (Step 4 of 4)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Row(
                    children: [
                      // Step 4 - Filled Pink (Full Bar)
                      Expanded(
                        flex: 4,
                        child: Container(
                          height: 4.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF09AB1),
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
                      "Step 4 of 4",
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 30.h),

                // Icon Circle (Person Icon)
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
                      AppIcons
                          .bIRTHDAY,
                      // Using birthay icon as requested or maybe person
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
                    "WHEN IS YOUR BIRTHDAY?",
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
                  "This helps personalize your experience",
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    color: const Color(0xFF6B7280),
                  ),
                ),

                SizedBox(height: 30.h),

                // Date Picker Card
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 24.w),
                  padding: EdgeInsets.symmetric(
                      horizontal: 24.w, vertical: 24.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Date of Birth",
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF4A4A4A),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Date Field
                      GestureDetector(
                        onTap: () async {
                          // Using Cuperdino or Material Date Picker?
                          // Let's use standard Date Picker for now
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime(2000),
                            // Reasonable default
                            firstDate: DateTime(1950),
                            lastDate: DateTime.now(),
                            builder: (context, child) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: Color(0xFFF09AB1),
                                    onPrimary: Colors.white,
                                    onSurface: Colors.black87,
                                  ),
                                  dialogBackgroundColor: Colors.white,
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            controller.onDateSelected(picked);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 14.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFFF9),
                            border: Border.all(
                              color: const Color(0xFFFFE0E6),
                            ), // Light pink border
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Obx(
                                      () =>
                                      Text(
                                        controller.dateText.value.isNotEmpty
                                            ? controller.dateText.value
                                            : "MM/DD/YYYY",
                                        style: GoogleFonts.playfairDisplay(
                                          fontSize: 16.sp,
                                          color:
                                          controller.dateText.value.isNotEmpty
                                              ? const Color(0xFF2D3142)
                                              : const Color(0xFF9CA3AF),
                                        ),
                                      ),
                                ),
                              ),
                              Icon(
                                Icons.calendar_today_outlined,
                                color: const Color(0xFFF09AB1),
                                size: 20.sp,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Disclaimer Text
                      Text(
                        "This helps us personalize meal recommendations for your age",
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          color: const Color(0xFF6B7280),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30.h),

                // Bottom Buttons (Back & Complete Setup)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Row(
                    children: [
                      // Back Button
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 56.h,
                          child: ElevatedButton(
                            onPressed: controller.back,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF4A4A4A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                              elevation: 2,
                              shadowColor: Colors.black12,
                            ),
                            child: Text(
                              "Back",
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      // Complete Setup Button
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 56.h,
                          child: Obx(
                                () =>
                                ElevatedButton(
                                  onPressed: controller.isLoading.value
                                      ? null
                                      : controller.completeSetup,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(
                                      0xFFF09AB1,
                                    ),
                                    // Pink color
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.r),
                                    ),
                                    elevation: 5,
                                    shadowColor: const Color(
                                      0xFFF09AB1,
                                    ).withOpacity(0.4),
                                  ),
                                  child: controller.isLoading.value
                                      ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                      : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Complete Setup",
                                        style: GoogleFonts.playfairDisplay(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 14.sp,
                                      ),
                                    ],
                                  ),
                                ),
                          ),
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
