import 'dart:convert';
import 'package:get/get.dart';
import '../../../../Utils/AppIcons/app_icons.dart';
import '../../../../helper/shared_prefe/shared_prefe.dart';
import '../../../../helper/toast_helper.dart';
import '../../../../service/api_url.dart';
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
      final token = await SharePrefsHelper.getString(SharedPreferenceValue.token);
      final body = {
        "dietaryRestrictions": selectedRestrictions.toList()
      };
      
      final formData = FormData({
        "data": jsonEncode(body)
      });
      
      final response = await GetConnect().patch(
        "${ApiConstant.baseUrl}${ApiConstant.userProfile}",
        formData,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ToastHelper.showSuccess("Health Setup completed successfully!");
        Get.offAll(() => const ClientHomeScreen());
      } else {
        ToastHelper.showError(response.body?['message'] ?? "Failed to save data");
      }
    } catch (e) {
      ToastHelper.showError("Network error: $e");
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
