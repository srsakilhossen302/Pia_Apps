import 'dart:async';
import 'package:get/get.dart';
import '../Reset_Password/reset_password_screen.dart';

class VerifyCodeController extends GetxController {
  String email = "";
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
      try {
        // TODO: Implement Verify OTP API logic here
        print("Verify Logic: OTP: ${otp.value}");

        // Simulate API call
        await Future.delayed(const Duration(seconds: 2));

        Get.snackbar("Success", "Email verified successfully");

        // Navigate to Reset Password Screen
        Get.to(() => ResetPasswordScreen());
      } catch (e) {
        Get.snackbar("Error", "Invalid OTP");
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar("Error", "Please enter a valid 6-digit code");
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
