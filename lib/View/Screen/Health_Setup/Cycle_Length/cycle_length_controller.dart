import 'package:get/get.dart';
import '../../Health_Setup/Birthday/birthday_screen.dart';

class CycleLengthController extends GetxController {
  var selectedDays = 28.obs; // Default typically around 28 for cycles
  var isLoading = false.obs;

  // List of days from 1 to 31 (User requested 1-31, though cycles can be longer, I will stick to request)
  final List<int> days = List.generate(31, (index) => index + 1);

  void onDaysChanged(int index) {
    selectedDays.value = days[index];
  }

  Future<void> saveCycleLength() async {
    isLoading.value = true;
    try {
      // TODO: Implement POST API to save cycle length
      print("Saving Cycle Length: ${selectedDays.value} days");

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Navigate to next screen (Step 4)
      Get.snackbar("Success", "Cycle length saved successfully");

      // Navigate to Birthday Screen (Step 4)
      Get.to(() => BirthdayScreen());

      // Navigate to next screen - Placeholder for Step 4
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
  }
}
