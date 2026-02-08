import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import '../../../../Utils/AppIcons/app_icons.dart';
import 'dietary_restrictions_controller.dart';

class DietaryRestrictionsScreen extends StatelessWidget {
  final DietaryRestrictionsController controller = Get.put(
    DietaryRestrictionsController(),
  );

  DietaryRestrictionsScreen({super.key});

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

                // Progress Bar (Step 5 of 5)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Row(
                    children: [
                      // Step 5 - Filled Pink (Full Bar)
                      Expanded(
                        flex: 5,
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
                      "Step 5 of 5",
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 30.h),

                // Illustration
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
                      AppIcons.anydietaryrestrictions,
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
                    "ANY DIETARY RESTRICTIONS?",
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
                  "Select all that apply",
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    color: const Color(0xFF6B7280),
                  ),
                ),

                SizedBox(height: 30.h),

                // Options List
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      ...controller.dietaryOptions.map((option) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: Obx(() {
                            bool isSelected = controller.selectedRestrictions
                                .contains(option["id"]);
                            return GestureDetector(
                              onTap: () {
                                controller.toggleRestriction(option["id"]);
                              },
                              child: Container(
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFFFFF0F5)
                                      : Colors.white.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFFF09AB1)
                                        : const Color(0xFFFFE0E6),
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    // Icon
                                    Image.asset(
                                      option["icon"],
                                      width: 32.w,
                                      height: 32.h,
                                      // If the image is already colored, don't tint it.
                                      // If it needs to be tinted, uncomment next line.
                                      // color: const Color(0xFFF09AB1),
                                    ),
                                    SizedBox(width: 16.w),
                                    // Text
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            option["title"],
                                            style: GoogleFonts.playfairDisplay(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF4A4A4A),
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            option["subtitle"],
                                            style: GoogleFonts.poppins(
                                              fontSize: 12.sp,
                                              color: const Color(0xFF6B7280),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Checkmark for selection visual cue? Or rely on border color?
                                    // Let's rely on border/bg color change as per typical selectable card.
                                    // But maybe checkmark is better.
                                    // The user image shows checkmark for 'None' which is selected.
                                    if (isSelected)
                                      Container(
                                        padding: EdgeInsets.all(4.w),
                                        decoration: const BoxDecoration(
                                          color: Colors
                                              .green, // Checkmark color in image looks green
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 16.sp,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        );
                      }),
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
                            () => ElevatedButton(
                              onPressed: controller.isLoading.value
                                  ? null
                                  : controller.completeSetup,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF09AB1),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
