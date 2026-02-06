import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../Core/AppRoute/app_route.dart';
import 'client_profile_controller.dart';

class ClientProfileScreen extends StatelessWidget {
  ClientProfileScreen({super.key});

  final ClientProfileController controller = Get.put(ClientProfileController());

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
          "PROFILE",
          style: GoogleFonts.playfairDisplay(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          children: [
            // === Profile Header ===
            SizedBox(height: 20.h),
            Stack(
              children: [
                Container(
                  width: 100.w,
                  height: 100.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=200',
                      ),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF48FB1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 16.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),
            Text(
              controller.userName,
              style: GoogleFonts.playfairDisplay(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2D2D2D),
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              controller.cyclePhase,
              style: GoogleFonts.lato(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFF48FB1),
                letterSpacing: 1.0,
              ),
            ),

            SizedBox(height: 30.h),

            // === Personal Information Card ===
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "PERSONAL INFORMATION",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[800],
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  _buildInfoRow(
                    Icons.email_outlined,
                    "EMAIL",
                    controller.email,
                  ),
                  _buildDivider(),
                  _buildInfoRow(
                    Icons.cake_outlined,
                    "BIRTHDAY",
                    controller.birthday,
                  ),
                  _buildDivider(),
                  _buildInfoRow(
                    Icons.verified_user_outlined,
                    "SUBSCRIPTION STATUS",
                    controller.subscriptionStatus,
                    onTap: () {
                      Get.toNamed(AppRoute.clientSubscriptionScreen);
                    },
                    isAction: true, // Add identifier arrow if needed
                  ),
                  _buildDivider(),
                  _buildInfoRow(
                    Icons.favorite_border,
                    "HEALTH PROFILE",
                    "Step Up Your Health Profile",
                    isAction: true,
                  ),
                  _buildDivider(),
                  // Apple Health Switch
                  Row(
                    children: [
                      Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF0F3),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          Icons.watch,
                          color: const Color(0xFFF48FB1),
                          size: 20.sp,
                        ),
                      ),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Apple Health & Watch",
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              "Auto-sync active",
                              style: GoogleFonts.lato(
                                fontSize: 11.sp,
                                color: const Color(0xFFF48FB1),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Obx(
                        () => Switch(
                          value: controller.isHealthSyncEnabled.value,
                          onChanged: controller.toggleHealthSync,
                          activeColor: Colors.white,
                          activeTrackColor: const Color(0xFFF48FB1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // === Edit Profile Button ===
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: controller.editProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF48FB1),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                ),
                child: Text(
                  "EDIT PROFILE",
                  style: GoogleFonts.lato(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),

            SizedBox(height: 20.h),

            // === Account Actions Card ===
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ACCOUNT ACTIONS",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[800],
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  _buildActionRow(
                    Icons.lock_outline,
                    "Change Password",
                    onTap: controller.changePassword,
                  ),
                  _buildDivider(),
                  _buildActionRow(
                    Icons.delete_outline,
                    "Delete Account",
                    isDestructive: true,
                    onTap: controller.deleteAccount,
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // === Sign Out Button ===
            GestureDetector(
              onTap: controller.signOut,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0xFFFF5252).withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.logout,
                      color: const Color(0xFFFF5252),
                      size: 18.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      "Sign Out",
                      style: GoogleFonts.lato(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFFF5252),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 230.h),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    bool isAction = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0F3),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: const Color(0xFFF48FB1), size: 20.sp),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.lato(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[500],
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          if (isAction)
            Icon(Icons.chevron_right, size: 20.sp, color: Colors.grey[400]),
        ],
      ),
    );
  }

  Widget _buildActionRow(
    IconData icon,
    String label, {
    bool isDestructive = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            // Transparent bg for icons in actions section, or same style? Image shows icons without big bg, just icon.
            // Wait, image shows Lock has no bg, Delete has no bg but red color.
            // Actually they look like simple icons next to text.
            child: Icon(
              icon,
              color: isDestructive ? const Color(0xFFFF5252) : Colors.grey[700],
              size: 20.sp,
            ),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.playfairDisplay(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: isDestructive ? const Color(0xFFFF5252) : Colors.black87,
              ),
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: isDestructive
                ? const Color(0xFFFF5252).withOpacity(0.5)
                : Colors.grey[400],
            size: 20.sp,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: Divider(color: Colors.grey[100], thickness: 1),
    );
  }
}
