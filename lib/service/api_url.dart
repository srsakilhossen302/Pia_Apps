class ApiConstant {
  static const String baseUrl = 'http://10.10.7.50:4007';
  static const String apiVersion = "/api/v1";
  static const String socketUrl = baseUrl;

  // Auth

  static const String login = "$apiVersion/auth/login";
  static const String signUp = "$apiVersion/auth/signup";
  static const String verifyAccount = "$apiVersion/auth/verify-account";
}
