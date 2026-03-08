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
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator(color: Color(0xFFF48FB1)))
            : controller.plans.isEmpty
                ? _buildEmptyState()
                : SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0.h),
                    child: Column(
                      children: [
                        // === Header ===
                        _buildHeader(),
                        SizedBox(height: 25.h),

                        // === Plans List ===
                        ...controller.plans.map((plan) => _buildPlanCard(plan)),

                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
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
    );
  }

  Widget _buildPlanCard(SubscriptionPlanModel plan) {
    bool isRecommended = plan.name.contains("Pro");

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 25.h),
          padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25.r),
            border: isRecommended
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
                plan.name.toUpperCase(),
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  letterSpacing: 1.0,
                ),
              ),
              if (plan.description.isNotEmpty) ...[
                SizedBox(height: 8.h),
                Text(
                  plan.description,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
              SizedBox(height: 15.h),

              // Price
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "\$${plan.price}",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: plan.primaryColor,
                      ),
                    ),
                    TextSpan(
                      text: plan.formattedInterval,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 16.sp,
                        color: plan.primaryColor.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 25.h),

              // Features
              ...plan.features.map((feature) => _buildFeatureItem(feature, plan.primaryColor)),

              SizedBox(height: 25.h),

              // Button
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: () => controller.selectPlan(plan),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: plan.primaryColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                  ),
                  child: Text(
                    "Choose ${plan.name.split(' ').last}",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // === Badge for Pro/Recommended ===
        if (isRecommended)
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
                "Recommended",
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

  Widget _buildFeatureItem(String text, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 6.h),
            width: 5.w,
            height: 5.w,
            decoration: BoxDecoration(
              color: color.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.lato(
                fontSize: 14.sp,
                color: Colors.grey[800],
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        "No subscription plans available.",
        style: GoogleFonts.lato(color: Colors.grey),
      ),
    );
  }
}
