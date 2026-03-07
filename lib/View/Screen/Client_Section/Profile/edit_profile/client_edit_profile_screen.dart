import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../service/api_url.dart';
import 'client_edit_profile_controller.dart';

class ClientEditProfileScreen extends StatelessWidget {
  ClientEditProfileScreen({super.key});

  final ClientEditProfileController controller = Get.put(
    ClientEditProfileController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3F4), // Light pink background
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
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
          "EDIT PROFILE",
          style: GoogleFonts.playfairDisplay(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: Obx(() {
        final user = controller.profileController.userProfile.value;
        String profileImage = user?.profile != null
            ? (user!.profile!.startsWith('http')
                  ? user.profile!
                  : "${ApiConstant.baseUrl}${user.profile}")
            : 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=300';

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 30.h),

              // === Profile Image ===
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 110.w,
                      height: 110.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        image: DecorationImage(
                          image: controller.selectedImage.value != null
                              ? FileImage(controller.selectedImage.value!)
                                    as ImageProvider
                              : NetworkImage(profileImage),
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
                      bottom: 5.h,
                      right: 5.w,
                      child: GestureDetector(
                        onTap: () => _showImagePicker(context),
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
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.h),

              // === Name & Subtitle ===
              Text(
                user?.name ?? "N/A",
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2D2D2D),
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                (user?.role ?? "").toUpperCase(),
                style: GoogleFonts.lato(
                  fontSize: 12.sp,
                  color: const Color(0xFFF48FB1),
                ),
              ),

              SizedBox(height: 40.h),

              // === Form Fields ===
              _buildLabel("Full Name"),
              _buildTextField(controller.nameController, "Full Name"),

              SizedBox(height: 20.h),
              _buildLabel("Email Address"),
              _buildTextField(
                controller.emailController,
                "Email Address",
                readOnly: true,
              ),

              SizedBox(height: 20.h),
              _buildLabel("Birthday"),
              _buildTextField(
                controller.birthdayController,
                "MM/DD/YYYY",
                isDate: true,
                suffixIcon: Icon(
                  Icons.calendar_today_outlined,
                  color: const Color(0xFFF48FB1),
                  size: 20.sp,
                ),
              ),

              SizedBox(height: 40.h),

              // === Save Changes Button ===
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF48FB1),
                    elevation: 0,
                    shadowColor: const Color(0xFFF48FB1).withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          "SAVE CHANGES",
                          style: GoogleFonts.lato(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 1.0,
                          ),
                        ),
                ),
              ),

              SizedBox(height: 15.h),

              // === Cancel Button ===
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: controller.cancel,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                  ),
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.lato(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30.h),
            ],
          ),
        );
      }),
    );
  }

  void _showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Text(
                  "Choose Profile Picture",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFFF48FB1)),
                title: Text('Take a Photo', style: GoogleFonts.lato()),
                onTap: () {
                  Navigator.pop(context);
                  controller.pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Color(0xFFF48FB1)),
                title: Text('Choose from Gallery', style: GoogleFonts.lato()),
                onTap: () {
                  Navigator.pop(context);
                  controller.pickImage(ImageSource.gallery);
                },
              ),
              SizedBox(height: 20.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLabel(String label) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(bottom: 8.h),
      child: Text(
        label,
        style: GoogleFonts.playfairDisplay(
          fontSize: 15.sp,
          color: const Color(0xFF2D2D2D),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    bool isDate = false,
    bool readOnly = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: TextField(
        controller: controller,
        readOnly: isDate || readOnly,
        style: GoogleFonts.playfairDisplay(
          color: const Color(0xFF8A9EA8),
          fontSize: 16.sp,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.playfairDisplay(
            color: const Color(0xFF8A9EA8).withOpacity(0.6),
            fontSize: 16.sp,
          ),
          suffixIcon: suffixIcon,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 18.h,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
