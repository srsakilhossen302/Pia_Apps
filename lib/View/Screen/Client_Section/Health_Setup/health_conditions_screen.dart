import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pia/Utils/AppIcons/app_icons.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import 'health_conditions_controller.dart';

class HealthConditionsScreen extends StatelessWidget {
  final HealthConditionsController controller = Get.put(
    HealthConditionsController(),
  );

  HealthConditionsScreen({super.key});

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
                SizedBox(height: 50.h),

                // Header: HEALTH SETUP & Skip
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "HEALTH SETUP",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 24.sp,
                        color: const Color(0xFFF09AB1), // Pink title
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.skip,
                      child: Text(
                        "Skip",
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          color: const Color(0xFF4A5565),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Progress Bar
                Container(
                  width: double.infinity,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 1.0, // 100% progress for Step 5
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF09AB1),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Step 5 of 5",
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: const Color(0xFF4A5565),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                SizedBox(height: 30.h),

                // Icon Circle (Pill)
                Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFF09AB1).withOpacity(0.15),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      AppIcons.hEALTHCONDITIONS,
                      width: 32.w,
                      color: const Color(0xFFF09AB1),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),

                // Title Section
                Text(
                  "HEALTH CONDITIONS",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 28.sp,
                    color: const Color(0xFFF09AB1),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Tell us about any health concerns",
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    color: const Color(0xFF364153),
                  ),
                ),
                SizedBox(height: 30.h),

                // Main Form Card
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Allergies
                      Text(
                        "Allergies (Optional)",
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2D3142),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      TextFormField(
                        controller: controller.allergiesController,
                        maxLines: 2,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 14.sp,
                          color: const Color(0xFF2D3142),
                        ),
                        decoration: InputDecoration(
                          hintText: "E.g., dairy, nuts, gluten, shellfish...",
                          hintStyle: GoogleFonts.playfairDisplay(
                            color: const Color(0xFF9CA3AF),
                            fontSize: 14.sp,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFFFFFF9),
                          contentPadding: EdgeInsets.all(16.w),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: const BorderSide(
                              color: Color(0xFFF09AB1),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Conditions Checkboxes
                      Text(
                        "Do you have any of these conditions?",
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2D3142),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Obx(
                        () => Column(
                          children: controller.conditionsOptions.map((option) {
                            bool isSelected = controller.selectedConditions
                                .contains(option["code"]);
                            return GestureDetector(
                              onTap: () =>
                                  controller.toggleCondition(option["code"]!),
                              child: Container(
                                margin: EdgeInsets.only(bottom: 12.h),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 18.h,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFFFFE4E8)
                                      : const Color(0xFFFFF0F3).withOpacity(
                                          0.3,
                                        ), // Lighter pinkish bg
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: isSelected
                                      ? Border.all(
                                          color: const Color(0xFFF09AB1),
                                        )
                                      : Border.all(
                                          color: const Color(
                                            0xFFF09AB1,
                                          ).withOpacity(0.3),
                                        ), // Subtle Order
                                ),
                                child: Row(
                                  children: [
                                    // Checkbox
                                    Container(
                                      width: 20.w,
                                      height: 20.w,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? const Color(0xFFF09AB1)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(
                                          4.r,
                                        ),
                                        border: Border.all(
                                          color: const Color(0xFFF09AB1),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: isSelected
                                          ? Icon(
                                              Icons.check,
                                              size: 14.sp,
                                              color: Colors.white,
                                            )
                                          : null,
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: RichText(
                                        overflow: TextOverflow.visible,
                                        text: TextSpan(
                                          style: GoogleFonts.playfairDisplay(
                                            fontSize: 14.sp,
                                            color: const Color(0xFF2D3142),
                                          ),
                                          children: [
                                            TextSpan(
                                              text: "${option["code"]}  ",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(
                                              text: option["name"],
                                              style: GoogleFonts.poppins(
                                                color: const Color(0xFF6B7280),
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Other Health Conditions
                      Text(
                        "Other Health Conditions (Optional)",
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2D3142),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      TextFormField(
                        controller: controller.otherConditionsController,
                        maxLines: 2,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 14.sp,
                          color: const Color(0xFF2D3142),
                        ),
                        decoration: InputDecoration(
                          hintText: "E.g., endometriosis, thyroid issues...",
                          hintStyle: GoogleFonts.playfairDisplay(
                            color: const Color(0xFF9CA3AF),
                            fontSize: 14.sp,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFFFFFF9),
                          contentPadding: EdgeInsets.all(16.w),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: const BorderSide(
                              color: Color(0xFFF09AB1),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Privacy Note
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF5F7), // Light pink/beige
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              color: const Color(0xFF4A4A4A),
                            ),
                            children: [
                              TextSpan(
                                text: "Privacy: ",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const TextSpan(
                                text:
                                    "Your health information is stored locally on your device and never shared.",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 48.h),

                // Bottom Buttons (Back & Complete Setup)
                SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 56.h,
                          child: ElevatedButton(
                            onPressed: controller.back,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF2D3142),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.r),
                                side: const BorderSide(color: Colors.white),
                              ),
                              elevation: 0,
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
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 56.h,
                          child: ElevatedButton(
                            onPressed: controller.completeSetup,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF09AB1),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Complete Setup",
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16.sp,
                                  color: Colors.white,
                                ),
                              ],
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
