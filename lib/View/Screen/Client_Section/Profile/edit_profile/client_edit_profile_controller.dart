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

  Future<void> pickImage() async {
    try {
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
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

      final Map<String, dynamic> body = {};
      if (nameController.text.isNotEmpty)
        body["name"] = nameController.text.trim();

      if (selectedImage.value != null) {
        body["images"] = MultipartFile(
          selectedImage.value!,
          filename: selectedImage.value!.path.split('/').last,
        );
      }

      final formData = FormData(body);

      final response = await GetConnect().patch(
        "${ApiConstant.baseUrl}${ApiConstant.userProfile}",
        formData,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ToastHelper.showSuccess(
          response.body['message'] ?? "Profile updated successfully",
        );
        profileController
            .getUserProfile(); // refresh the profile data in the background
        Get.back();
      } else {
        ToastHelper.showError(
          response.body['message'] ?? "Failed to update profile",
        );
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
