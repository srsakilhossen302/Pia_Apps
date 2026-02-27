import 'dart:async';
import 'package:get/get.dart';
import '../Reset_Password/reset_password_screen.dart';
import '../../Health_Setup/Period_Start/period_start_screen.dart';
import '../../../../helper/shared_prefe/shared_prefe.dart';
import '../../../../helper/toast_helper.dart';
import '../../../../service/api_url.dart';

class VerifyCodeController extends GetxController {
  String email = "";
  String source = "";
  var otp = "".obs;
  var isLoading = false.obs;
  var timerValue = 59.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    // Get arguments if passed, e.g. email
    if (Get.arguments != null) {
      email = Get.arguments['email'] ?? "your@email.com";
      source = Get.arguments['source'] ?? "";
    } else {
      email = "your@email.com"; // Default for preview
    }
    startTimer();
  }

  void startTimer() {
    timerValue.value = 59;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerValue.value > 0) {
        timerValue.value--;
      } else {
        _timer?.cancel();
      }
    });
  }

  void resendCode() {
    if (timerValue.value == 0) {
      // Logic to resend code
      print("Resending code to $email");
      startTimer();
      Get.snackbar("Sent", "New code sent to your email");
    }
  }

  Future<void> verifyCode() async {
    if (otp.value.length == 6) {
      isLoading.value = true;
      update();
      try {
        final body = {"email": email.trim(), "oneTimeCode": otp.value.trim()};

        print("Verification Request Body: $body");

        final response = await GetConnect().post(
          "${ApiConstant.baseUrl}${ApiConstant.verifyAccount}",
          body,
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          final data = response.body['data'];

          // Get token (check for 'accessToken' or just 'token' from forgot password response)
          final String token = data['accessToken'] ?? data['token'] ?? "";

          // Save token and email to SharedPreferences
          if (token.isNotEmpty) {
            await SharePrefsHelper.setString(
              SharedPreferenceValue.token,
              token,
            );
            await SharePrefsHelper.setString(
              SharedPreferenceValue.email,
              email.trim(),
            );
          }

          ToastHelper.showSuccess(
            response.body['message'] ?? "Email verified successfully",
          );

          Get.focusScope?.unfocus();

          // Navigate based on source
          if (source == 'sign_up') {
            Get.offAll(() => PeriodStartScreen());
          } else {
            Get.to(() => ResetPasswordScreen());
          }
        } else {
          ToastHelper.showError(
            response.body['message'] ?? "Verification failed",
          );
        }
      } catch (e) {
        ToastHelper.showError("Network error. Please try again.");
      } finally {
        isLoading.value = false;
        update();
      }
    } else {
      ToastHelper.showError("Please enter a valid 6-digit code");
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
