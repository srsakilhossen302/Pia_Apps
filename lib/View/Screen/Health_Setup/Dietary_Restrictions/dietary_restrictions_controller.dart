import 'package:get/get.dart';
import '../../../../Utils/AppIcons/app_icons.dart';
import '../../Client_Section/Home/client_home_screen.dart';

class DietaryRestrictionsController extends GetxController {
  // List of available dietary options with their details
  final List<Map<String, dynamic>> dietaryOptions = [
    {
      "id": "vegan",
      "title": "Vegan",
      "subtitle": "Plant-based diet",
      "icon": AppIcons.vegan,
    },
    {
      "id": "vegetarian",
      "title": "Vegetarian",
      "subtitle": "No meat or fish",
      "icon": AppIcons.vegetarian,
    },
    {
      "id": "dairy_free",
      "title": "Dairy Free",
      "subtitle": "No dairy products",
      "icon": AppIcons.dairyFree,
    },
    {
      "id": "gluten_free",
      "title": "Gluten Free",
      "subtitle": "No gluten",
      "icon": AppIcons.glutenFree,
    },
    {
      "id": "nut_allergy",
      "title": "Nut Allergy",
      "subtitle": "Allergic to nuts",
      "icon": AppIcons.nutAllergy,
    },
    {
      "id": "none",
      "title": "None",
      "subtitle": "No restrictions",
      "icon": AppIcons.none,
    },
  ];

  // Selected restrictions
  var selectedRestrictions = <String>[].obs;
  var isLoading = false.obs;

  void toggleRestriction(String id) {
    if (id == "none") {
      // If none is selected, clear others and toggle none
      if (selectedRestrictions.contains("none")) {
        selectedRestrictions.remove("none");
      } else {
        selectedRestrictions.clear();
        selectedRestrictions.add("none");
      }
    } else {
      // If other option selected, remove "none" if present
      if (selectedRestrictions.contains("none")) {
        selectedRestrictions.remove("none");
      }

      if (selectedRestrictions.contains(id)) {
        selectedRestrictions.remove(id);
      } else {
        selectedRestrictions.add(id);
      }
    }
  }

  Future<void> completeSetup() async {
    isLoading.value = true;
    try {
      // TODO: Implement POST API to save dietary restrictions
      print("Saving Dietary Restrictions: ${selectedRestrictions.join(', ')}");

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      Get.snackbar("Success", "Health Setup completed successfully!");

      // Navigate to Home Screen
      Get.offAll(() => const ClientHomeScreen());
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
    Get.offAll(() => const ClientHomeScreen());
  }
}
