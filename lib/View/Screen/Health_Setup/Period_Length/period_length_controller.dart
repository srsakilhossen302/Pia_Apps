import 'package:get/get.dart';

class PeriodLengthController extends GetxController {
  var selectedDays = 5.obs; // Default to 5 days
  var isLoading = false.obs;

  // List of days from 1 to 31
  final List<int> days = List.generate(31, (index) => index + 1);

  void onDaysChanged(int index) {
    selectedDays.value = days[index];
  }

  Future<void> savePeriodLength() async {
    isLoading.value = true;
    try {
      // TODO: Implement POST API to save period length
      print("Saving Period Length: ${selectedDays.value} days");

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Navigate to next screen (Step 3)
      // For now, staying here or going back to home as placeholder
      // User hasn't finished flow, but I will simulate success.
      // Next step would be "Cycle Length" usually.
      // For now, I'll show a snackbar and maybe navigate to Home if no next step defined yet.
      Get.snackbar("Success", "Period length saved successfully");

      // Navigate to next screen - Placeholder
      // Get.to(() => NextScreen());
    } catch (e) {
      Get.snackbar("Error", "Failed to save data");
    } finally {
      isLoading.value = false;
    }
  }

  void back() {
    Get.back();
  }

  void skip() {
    // Navigate to dashboard or next step skipping this
    // For now assuming skip goes to next step or home
    // Get.offAll(() => ClientHomeScreen());
  }
}
