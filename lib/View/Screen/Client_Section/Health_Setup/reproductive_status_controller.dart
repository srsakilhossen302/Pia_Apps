import 'package:get/get.dart';
import '../../../../Model/Client_Section/reproductive_status_model.dart';
import 'exercise_level_screen.dart';
// import 'next_screen.dart'; // Will import the next screen later

class ReproductiveStatusController extends GetxController {
  var selectedStatus = "None".obs;

  final List<Map<String, String>> options = [
    {"title": "None", "subtitle": "Not applicable"},
    {"title": "Perimenopause", "subtitle": "Transitioning to menopause"},
    {"title": "Menopause", "subtitle": "Post-menopausal"},
    {"title": "Pregnant", "subtitle": "Currently pregnant"},
    {"title": "Trying to Conceive", "subtitle": "Planning pregnancy"},
  ];

  // Model instance
  var reproductiveStatus = ReproductiveStatusModel().obs;

  void selectStatus(String status) {
    selectedStatus.value = status;
    reproductiveStatus.update((val) {
      val?.selectedStatus = status;
    });
  }

  void nextStep() {
    print("Next Step Data: ${reproductiveStatus.value.toJson()}");
    Get.snackbar("Success", "Status saved!");
    // Navigate to Step 3
    Get.to(() => ExerciseLevelScreen());
  }

  void back() {
    Get.back();
  }

  void skip() {
    // Logic to skip or same as next
    nextStep();
  }
}
