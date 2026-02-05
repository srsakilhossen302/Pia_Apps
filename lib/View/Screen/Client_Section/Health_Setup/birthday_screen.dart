import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pia/Utils/AppIcons/app_icons.dart';
import '../../../../Utils/AppColors/app_colors.dart';
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
                  child: Row(
                    children: [
                      Container(
                        width:
                            MediaQuery.of(context).size.width *
                            0.75, // Step 4 of 5 approx
                        decoration: BoxDecoration(
                          color: const Color(0xFFF09AB1),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Step 4 of 5",
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: const Color(0xFF4A5565),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                SizedBox(height: 30.h),

                // Icon Circle (User/Person)
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
                      AppIcons
                          .bIRTHDAY, // Assuming this is the user icon for birthday
                      width: 32.w,
                      color: const Color(0xFFF09AB1),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),

                // Title Section
                Text(
                  "BIRTHDAY",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 30.sp,
                    color: const Color(0xFFF09AB1),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "When were you born?",
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
                      // Date of Birth Label
                      Text(
                        "Date of Birth",
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2D3142),
                        ),
                      ),
                      SizedBox(height: 12.h),

                      // Date Picker Field
                      GestureDetector(
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime(
                              2000,
                            ), // Default to some adult age
                            firstDate: DateTime(1950),
                            lastDate: DateTime.now(),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: Color(0xFFF09AB1),
                                    onPrimary: Colors.white,
                                    onSurface: Colors.black,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            controller.updateDate(picked);
                          }
                        },
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: controller.dateController,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 14.sp,
                              color: const Color(0xFF2D3142),
                            ),
                            decoration: InputDecoration(
                              hintText: "MM/DD/YYYY",
                              hintStyle: GoogleFonts.playfairDisplay(
                                color: const Color(0xFF9CA3AF),
                                fontSize: 14.sp,
                              ),
                              suffixIcon: Image.asset(
                                AppIcons
                                    .pERIODINFO, // Reusing calendar icon from period info or specific birthday calendar if different
                                width: 24.w,
                                color: const Color(0xFFF09AB1),
                              ),
                              filled: true,
                              fillColor: const Color(0xFFFFFFF9),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 16.h,
                                horizontal: 20.w,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  16.r,
                                ), // Slightly tighter radius as per image? Or stick to 30. Image looks like 16-20.
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
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Helper Text
                      Text(
                        "This helps us personalize meal recommendations for your age",
                        style: GoogleFonts.poppins(
                          fontSize: 13.sp,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 120.h), // Spacing to push buttons down
                // Bottom Buttons (Back & Continue)
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
                            onPressed: controller.nextStep,
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
                                  "Continue",
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
