import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'client_payment_controller.dart';

class ClientPaymentScreen extends StatelessWidget {
  ClientPaymentScreen({super.key});

  final ClientPaymentController controller = Get.put(ClientPaymentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3F4), // Light pink background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.w),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back, color: Colors.black, size: 20.sp),
          ),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          "PAYMENT METHOD",
          style: GoogleFonts.playfairDisplay(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            letterSpacing: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),

            // === Select Payment Method ===
            Text(
              "Select Payment Method",
              style: GoogleFonts.playfairDisplay(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF2D2D2D),
              ),
            ),
            SizedBox(height: 15.h),

            Obx(
              () => Column(
                children: [
                  _buildPaymentOption(
                    index: 0,
                    icon: Icons.credit_card,
                    label: "Credit/Debit Card",
                    isSelected: controller.selectedPaymentMethod.value == 0,
                  ),
                  SizedBox(height: 15.h),
                  _buildPaymentOption(
                    index: 1,
                    icon: Icons.account_balance_wallet_outlined,
                    label: "Apple/Google Pay",
                    isSelected: controller.selectedPaymentMethod.value == 1,
                  ),
                ],
              ),
            ),

            SizedBox(height: 30.h),

            // === Card Details (Only if card selected) ===
            Obx(() {
              if (controller.selectedPaymentMethod.value == 0) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Card Details",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF2D2D2D),
                      ),
                    ),
                    SizedBox(height: 15.h),

                    _buildLabel("Card Number"),
                    _buildTextField(
                      "0000 0000 0000 0000",
                      icon: Icons.lock_outline,
                    ),

                    SizedBox(height: 15.h),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("Expiry Date"),
                              _buildTextField("MM/YY"),
                            ],
                          ),
                        ),
                        SizedBox(width: 15.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("CVV"),
                              _buildTextField("123"),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 15.h),
                    _buildLabel("Cardholder Name"),
                    _buildTextField("Name as on card"),
                  ],
                );
              }
              return SizedBox.shrink();
            }),

            SizedBox(height: 30.h),

            // === Summary Box ===
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: const Color(
                  0xFFFFEBEE,
                ), // Slightly darker pink for summary bg
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Monthly Subscription",
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        "\$14.99",
                        style: GoogleFonts.lato(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Divider(
                      color: const Color(0xFFF48FB1).withOpacity(0.3),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Due",
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        "\$14.99",
                        style: GoogleFonts.lato(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFF4081), // Hot pink for total
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 30.h),

            // === Confirm Button ===
            SizedBox(
              width: double.infinity,
              height: 55.h,
              child: ElevatedButton(
                onPressed: controller.confirmSubscription,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF48FB1),
                  elevation: 5,
                  shadowColor: const Color(0xFFF48FB1).withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                child: Text(
                  "CONFIRM SUBSCRIPTION",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),

            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required int index,
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => controller.selectPaymentMethod(index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black87),
            SizedBox(width: 15.w),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 14.sp,
                  color: Colors.black87,
                ),
              ),
            ),
            // Radio Button Custom
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFFF4081)
                      : Colors.grey[300]!,
                  width: isSelected ? 6.w : 1.w, // Simulated filled circle
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: GoogleFonts.playfairDisplay(
          fontSize: 14.sp,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, {IconData? icon}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.lato(color: Colors.grey[300]),
          suffixIcon: icon != null ? Icon(icon, color: Colors.grey[400]) : null,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 15.h,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
