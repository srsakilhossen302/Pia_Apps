import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../Utils/AppColors/app_colors.dart';
import '../../../../Utils/AppIcons/app_icons.dart';
import '../Sign_Up/sign_up_screen.dart';
import 'sign_in_controller.dart';

class SignInScreen extends StatelessWidget {
  final SignInController controller = Get.put(SignInController());

  SignInScreen({super.key});

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
                SizedBox(height: 60.h),
                // Logo
                Image.asset(
                  AppIcons.signInLogo,
                  height: 126.h,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 20.h),

                // Title
                Text(
                  "Welcome back",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 16.sp,
                    color: const Color(0xFF4A5565), // Darker brownish gray
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 30.h),

                // Form Card
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 32.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.r),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(
                          0xFFF09AB1,
                        ).withOpacity(0.15), // Pinkish shadow
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Email Field
                        _buildLabel("Email"),
                        SizedBox(height: 8.h),
                        _buildTextField(
                          controller: controller.emailController,
                          hint: "your@email.com",
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || !GetUtils.isEmail(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.h),

                        // Password Field
                        _buildLabel("Password"),
                        SizedBox(height: 8.h),
                        Obx(
                          () => _buildTextField(
                            controller: controller.passwordController,
                            hint: "••••••••",
                            icon: Icons.lock_outline,
                            isPassword: true,
                            isObscure: !controller.isPasswordVisible.value,
                            onToggleVisibility:
                                controller.togglePasswordVisibility,
                            validator: (value) {
                              if (value == null || value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 12.h),

                        // Forgot Password
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: controller.forgotPassword,
                            child: Text(
                              "Forgot password?",
                              style: GoogleFonts.poppins(
                                color: const Color(0xFFF09AB1),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // Sign In Button
                        SizedBox(
                          width: double.infinity,
                          height: 48.h,
                          child: Obx(
                            () => ElevatedButton(
                              onPressed: controller.isLoading.value
                                  ? null
                                  : controller.signIn,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                  0xFFF09AB1,
                                ), // Pinkish color matching design
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                elevation: 0,
                              ),
                              child: controller.isLoading.value
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      "Sign In",
                                      style: GoogleFonts.poppins(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                            ),
                          ),
                        ),

                        SizedBox(height: 20.h),

                        // Divider
                        Row(
                          children: [
                            Expanded(child: Divider(color: Colors.grey[300])),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: Text(
                                "or",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey[500],
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                            Expanded(child: Divider(color: Colors.grey[300])),
                          ],
                        ),

                        SizedBox(height: 20.h),

                        // Sign Up Logic
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Get.offAll(() => SignUpScreen());
                            },
                            child: RichText(
                              text: TextSpan(
                                text: "Don't have an account? ",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey[600],
                                  fontSize: 14.sp,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Sign Up",
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xFFF09AB1),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.playfairDisplay(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF4A4A4A),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool isObscure = false,
    VoidCallback? onToggleVisibility,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      keyboardType: keyboardType,
      validator: validator,
      style: GoogleFonts.playfairDisplay(
        fontSize: 16.sp,
        color: const Color(0xFF2D3142), // Darker text color
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.playfairDisplay(
          color: const Color(0xFF9CA3AF),
          fontSize: 16.sp,
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 20.w, right: 12.w),
          child: Icon(icon, color: const Color(0xFF999CAD), size: 24.sp),
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isObscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: Colors.grey[400],
                  size: 20.sp,
                ),
                onPressed: onToggleVisibility,
              )
            : null,
        contentPadding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 20.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r), // Pill shape
          borderSide: const BorderSide(color: Color(0xFFFFE0E6)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
          borderSide: const BorderSide(
            color: Color(0xFFFFE0E6),
          ), // Light pink border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
          borderSide: const BorderSide(
            color: Color(0xFFF09AB1),
          ), // Focused pink
        ),
        fillColor: const Color(0xFFFFFFF9),
        filled: true,
      ),
    );
  }
}
