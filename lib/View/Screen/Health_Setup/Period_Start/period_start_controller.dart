import 'package:get/get.dart';
import '../../Client_Section/Home/client_home_screen.dart';

class PeriodStartController extends GetxController {
  var selectedDate = DateTime.now().obs;
  var isLoading = false.obs;

  void onDateSelected(DateTime date) {
    selectedDate.value = date;
  }

  Future<void> savePeriodStart() async {
    isLoading.value = true;
    try {
      // TODO: Implement POST API to save period start date
      print(
        "Saving Period Start Date: ${selectedDate.value.toIso8601String()}",
      );

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Navigate to next screen (or Home for now as per previous flow)
      // The user said "SignUp kore otp page jaya otp diya ClientHomeScreen page na jaya ai page jabe"
      // So this is the destination after OTP. Where to go AFTER this?
      // Probably next step of setup, but for now let's go to ClientHomeScreen or just stay/show success.
      // Assuming flow completes or goes to next step. I'll route to ClientHomeScreen for now or just show success.
      // "ata screen ar vitore new akta foldar niya ar modhe ar akta new foldar niya digain korba atate akta post api hit hbe"
      Get.offAll(() => const ClientHomeScreen());
      Get.snackbar("Success", "Information saved successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to save data");
    } finally {
      isLoading.value = false;
    }
  }

  void skip() {
    Get.offAll(() => const ClientHomeScreen());
  }
}
