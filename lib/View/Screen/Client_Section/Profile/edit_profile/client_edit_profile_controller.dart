import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../helper/shared_prefe/shared_prefe.dart';
import '../../../../../helper/toast_helper.dart';
import '../../../../../service/api_url.dart';
import '../client_profile_controller.dart';

class ClientEditProfileController extends GetxController {
  late TextEditingController nameController;
  late TextEditingController emailController; // Postman optional
  late TextEditingController phoneController;
  late TextEditingController birthdayController;

  var isLoading = false.obs;
  var selectedImage = Rxn<File>();
  final picker = ImagePicker();

  final ClientProfileController profileController =
      Get.find<ClientProfileController>();

  @override
  void onInit() {
    super.onInit();
    final user = profileController.userProfile.value;

    nameController = TextEditingController(text: user?.name ?? "");
    emailController = TextEditingController(text: user?.email ?? "");
    phoneController = TextEditingController(text: user?.phone ?? "");
    birthdayController = TextEditingController(text: "");
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
      }
    } catch (e) {
      debugPrint("Image picking failed: $e");
    }
  }

  Future<void> saveChanges() async {
    isLoading.value = true;
    try {
      final token = await SharePrefsHelper.getString(
        SharedPreferenceValue.token,
      );

      if (token == null || token.isEmpty) {
        ToastHelper.showError("Authentication token is missing.");
        return;
      }

      // Preparation of text data according to Postman screenshot
      final Map<String, dynamic> dataMap = {};
      if (nameController.text.isNotEmpty) {
        dataMap["name"] = nameController.text.trim();
      }
      // Add other fields if required by your API inside the data object
      // dataMap["phone"] = phoneController.text.trim(); 

      final Map<String, dynamic> body = {
        "data": jsonEncode(dataMap),
      };

      // Handling the image file with key 'Images' as per Postman
      if (selectedImage.value != null) {
        body["Images"] = MultipartFile(
          selectedImage.value!.readAsBytesSync(),
          filename: selectedImage.value!.path.split(Platform.isWindows ? '\\' : '/').last,
        );
      }

      final formData = FormData(body);

      final response = await GetConnect().patch(
        "${ApiConstant.baseUrl}${ApiConstant.userProfile}",
        formData,
        headers: {
          'Authorization': 'Bearer $token',
          // GetConnect handles Content-Type for FormData automatically
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ToastHelper.showSuccess(
          (response.body != null && response.body['message'] != null)
              ? response.body['message']
              : "Profile updated successfully",
        );
        profileController.getUserProfile(); // Refresh profile in background
        Get.back();
      } else {
        // Detailed error message for debugging
        String errorMsg = "Failed to update profile";
        if (response.body != null && response.body['message'] != null) {
          errorMsg = response.body['message'];
        } else if (response.statusText != null) {
          errorMsg = response.statusText!;
        }
        
        ToastHelper.showError("Error (${response.statusCode}): $errorMsg");
        print("Update Profile Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      ToastHelper.showError("Network error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void cancel() {
    Get.back();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    birthdayController.dispose();
    super.onClose();
  }
}
