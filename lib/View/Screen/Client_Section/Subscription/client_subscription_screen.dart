import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../Model/Client_Section/subscription_model.dart';
import 'client_subscription_controller.dart';

class ClientSubscriptionScreen extends StatelessWidget {
  ClientSubscriptionScreen({super.key});

  final ClientSubscriptionController controller = Get.put(
    ClientSubscriptionController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3F4), // Light pink background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0.h),
        child: Column(
          children: [
            // === Header ===
            Row(
              children: [
                Icon(
                  Icons.workspace_premium_outlined,
                  color: const Color(0xFFF48FB1),
                  size: 24.sp,
                ),
                SizedBox(width: 10.w),
                Text(
                  "UPGRADE TO PREMIUM",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            SizedBox(height: 25.h),

            // === Plans List ===
            Column(
              children: controller.plans
                  .map((plan) => _buildPlanCard(plan))
                  .toList(),
            ),

            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(SubscriptionPlan plan) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 20.h),
          padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25.r),
            border: plan.isRecommended
                ? Border.all(color: plan.primaryColor, width: 1.5)
                : Border.all(color: Colors.transparent),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                plan.title,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 16.sp,
                  color: Colors.black87,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(height: 10.h),

              // Price
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: plan.price,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: plan.primaryColor,
                      ),
                    ),
                    TextSpan(
                      text: plan.duration,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 16.sp,
                        color: plan.primaryColor.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              if (plan.subtitle != null) ...[
                SizedBox(height: 5.h),
                Text(
                  plan.subtitle!,
                  style: GoogleFonts.lato(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],

              SizedBox(height: 25.h),

              // Features
              ...plan.features.map((feature) => _buildFeatureItem(feature)),

              SizedBox(height: 25.h),

              // Button
              SizedBox(
                width: double.infinity,
                height: 45.h,
                child: ElevatedButton(
                  onPressed: () => controller.selectPlan(plan),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: plan.primaryColor.withOpacity(
                      plan.isRecommended ? 1.0 : 0.8,
                    ), // Adjust opacity slightly
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                  ),
                  child: Text(
                    plan.buttonText,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 14.sp,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // === Badge ===
        if (plan.badgeText != null)
          Positioned(
            top: -12.h,
            right: 20.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: plan.primaryColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                plan.badgeText!,
                style: GoogleFonts.lato(
                  fontSize: 12.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(
              color: const Color(0xFFF48FB1).withOpacity(0.7),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.playfairDisplay(
                fontSize: 14.sp,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
