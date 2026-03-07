class ApiConstant {
  static const String baseUrl = 'http://10.10.7.50:4007';
  static const String apiVersion = "/api/v1";
  static const String socketUrl = baseUrl;

  // Auth

  static const String login = "$apiVersion/auth/login";
  static const String signUp = "$apiVersion/auth/signup";
  static const String verifyAccount = "$apiVersion/auth/verify-account";
  static const String forgetPassword = "$apiVersion/auth/forget-password";
  static const String resetPassword = "$apiVersion/auth/reset-password";
  static const String changePassword = "$apiVersion/auth/change-password";
  static const String resendOtp = "$apiVersion/auth/resend-otp";
  static const String recipe = "$apiVersion/recipe";
  static const String userProfile = "$apiVersion/user/profile";
  static const String cycleOverview = "$apiVersion/cycle/overview";
  static const String cycleCalendar = "$apiVersion/cycle/calendar";
  static const String cyclePhase = "$apiVersion/cycle/phase";
}
