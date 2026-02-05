import 'package:get/get.dart';
import '../../../../Model/Client_Section/exercise_level_model.dart';
import 'birthday_screen.dart';
// import 'next_screen.dart';

class ExerciseLevelController extends GetxController {
  var selectedLevel = "Moderate".obs;

  final List<Map<String, String>> options = [
    {"title": "Sedentary", "subtitle": "Little or no exercise"},
    {"title": "Light", "subtitle": "Exercise 1-3 days/week"},
    {"title": "Moderate", "subtitle": "Exercise 3-5 days/week"},
    {"title": "Active", "subtitle": "Exercise 6-7 days/week"},
    {"title": "Very Active", "subtitle": "Intense exercise daily"},
  ];

  // Model instance
  var exerciseLevel = ExerciseLevelModel().obs;

  void selectLevel(String level) {
    selectedLevel.value = level;
    exerciseLevel.update((val) {
      val?.selectedLevel = level;
    });
  }

  void nextStep() {
    print("Next Step Data: ${exerciseLevel.value.toJson()}");
    Get.snackbar("Success", "Exercise level saved!");
    // Navigate to Step 4
    Get.to(() => BirthdayScreen());
  }

  void back() {
    Get.back();
  }

  void skip() {
    nextStep();
  }
}
