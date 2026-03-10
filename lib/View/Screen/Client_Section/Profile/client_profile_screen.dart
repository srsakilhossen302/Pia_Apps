import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../Core/AppRoute/app_route.dart';
import '../../../../service/api_url.dart';
import 'client_profile_controller.dart';
import '../../Health_Setup/Period_Start/period_start_screen.dart';

class ClientProfileScreen extends StatelessWidget {
  ClientProfileScreen({super.key});

  final ClientProfileController controller = Get.put(ClientProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6F7), // Soft pink background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 70.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_back, color: Colors.black, size: 20.sp),
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          "PROFILE",
          style: GoogleFonts.playfairDisplay(
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2D2D2D),
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFF48FB1)),
          );
        }

        final user = controller.userProfile.value;
        if (user == null) {
          return const Center(child: Text("Failed to load profile"));
        }

        String profileImage = user.profile != null
            ? (user.profile!.startsWith('http')
                  ? user.profile!
                  : "${ApiConstant.baseUrl}${user.profile}")
            : 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=200';

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 15.h),
          child: Column(
            children: [
              // === Profile Header ===
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 120.w,
                      height: 120.w,
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(profileImage),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                user.name ?? "Sarah Johnson",
                style: GoogleFonts.playfairDisplay(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2D2D2D),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                "FOLLICULAR PHASE", // Mocking phase for now as per image
                style: GoogleFonts.lato(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFF48FB1),
                  letterSpacing: 1.5,
                ),
              ),

              SizedBox(height: 35.h),

              // === Personal Information Card ===
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 15,
                      offset: const Offset(0, 10),
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
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF2D2D2D),
                        letterSpacing: 1.0,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    _buildInfoItem(
                      icon: Icons.email_outlined,
                      label: "EMAIL",
                      value: user.email ?? "N/A",
                    ),
                    _buildInfoItem(
                      icon: Icons.cake_outlined,
                      label: "BIRTHDAY",
                      value: user.dateOfBirth != null
                          ? DateFormat(
                              'MMMM dd, yyyy',
                            ).format(user.dateOfBirth!)
                          : "N/A",
                    ),
                    _buildInfoItem(
                      icon: Icons.verified_user_outlined,
                      label: "SUBSCRIPTION STATUS",
                      value:
                          (user.subscriptionTier != null &&
                              user.subscriptionTier != 'free')
                          ? "${user.subscriptionTier![0].toUpperCase()}${user.subscriptionTier!.substring(1)} Plan"
                          : (user.trialUsed == false)
                          ? "Free Plan (Trial Available)"
                          : "Free Plan",
                      onTap: () =>
                          Get.toNamed(AppRoute.clientSubscriptionScreen),
                    ),
                    _buildInfoItem(
                      icon: Icons.favorite_border,
                      label: "HEALTH PROFILE",
                      value: "Step Up Your Health Profile",
                      onTap: () => Get.to(() => PeriodStartScreen()),
                    ),

                    // Apple Health
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF1F4),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            Icons.watch,
                            color: const Color(0xFFF48FB1),
                            size: 18.sp,
                          ),
                        ),
                        SizedBox(width: 16.w),
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
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Obx(
                          () => Switch(
                            value: controller.isHealthSyncEnabled.value,
                            onChanged: controller.toggleHealthSync,
                            activeColor: const Color(0xFFF48FB1),
                            activeTrackColor: const Color(
                              0xFFF48FB1,
                            ).withOpacity(0.3),
                            inactiveThumbColor: Colors.white,
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
                height: 52.h,
                child: ElevatedButton(
                  onPressed: controller.editProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF48FB1),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                  ),
                  child: Text(
                    "EDIT PROFILE",
                    style: GoogleFonts.lato(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              // === Account Actions Card ===
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 15,
                      offset: const Offset(0, 10),
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
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF2D2D2D),
                        letterSpacing: 1.0,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    _buildActionItem(
                      icon: Icons.lock_outline,
                      label: "Change Password",
                      onTap: controller.changePassword,
                    ),
                    _buildActionItem(
                      icon: Icons.delete_outline,
                      label: "Delete Account",
                      isDestructive: true,
                      onTap: controller.deleteAccount,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // === Sign Out ===
              GestureDetector(
                onTap: controller.signOut,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF6F7),
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                      color: const Color(0xFFF48FB1).withOpacity(0.1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout_rounded,
                        color: const Color(0xFFFF5252),
                        size: 18.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "Sign Out",
                        style: GoogleFonts.lato(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFFF5252),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 120.h),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(bottom: 20.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1F4),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: const Color(0xFFF48FB1), size: 18.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.lato(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey[500],
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    value,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(Icons.chevron_right, color: Colors.grey[300], size: 20.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String label,
    bool isDestructive = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(bottom: 18.h),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive
                  ? const Color(0xFFFF5252)
                  : const Color(0xFF2D2D2D),
              size: 20.sp,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: isDestructive
                      ? const Color(0xFFFF5252)
                      : const Color(0xFF2D2D2D),
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDestructive
                  ? const Color(0xFFFF5252).withOpacity(0.3)
                  : Colors.grey[200],
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }
}
