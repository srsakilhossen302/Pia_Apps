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
      ToastHelper.showError("Failed to pick image: $e");
    }
  }

  Future<void> selectBirthday(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFF48FB1),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      birthdayController.text =
          "${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}";
    }
  }

  Future<void> saveChanges() async {
    isLoading.value = true;
    try {
      final token =
          await SharePrefsHelper.getString(SharedPreferenceValue.token);
      if (token == null || token.isEmpty) {
        ToastHelper.showError("Authentication token is missing.");
        return;
      }

      // --- Prepare the 'data' part (JSON string) ---
      final Map<String, dynamic> dataMap = {};
      if (nameController.text.isNotEmpty) {
        dataMap["name"] = nameController.text.trim();
      }

      if (birthdayController.text.isNotEmpty) {
        try {
          List<String> parts = birthdayController.text.split('/');
          if (parts.length == 3) {
            DateTime dt = DateTime(
                int.parse(parts[2]), int.parse(parts[0]), int.parse(parts[1]));
            dataMap["dateOfBirth"] = dt.toUtc().toIso8601String();
          }
        } catch (e) {
          debugPrint("Date parsing failed: $e");
        }
      }

      // --- Prepare the body according to Postman screenshot ---
      final Map<String, dynamic> body = {
        "data": jsonEncode(dataMap), // Name/DOB inside JSON string
      };

      // Handle image if selected, key is 'images' based on screenshot
      if (selectedImage.value != null) {
        final bytes = await selectedImage.value!.readAsBytes();
        final fileName = selectedImage.value!.path
            .split(Platform.isWindows ? '\\' : '/')
            .last;
        final extension = fileName.split('.').last.toLowerCase();

        String contentType = 'image/jpeg';
        if (extension == 'png') contentType = 'image/png';
        if (extension == 'webp') contentType = 'image/webp';

        body["images"] = MultipartFile(
          bytes,
          filename: fileName,
          contentType: contentType,
        );
      }

      final formData = FormData(body);

      debugPrint("==== FINAL PROFILE UPDATE REQUEST ====");
      debugPrint("URL: ${ApiConstant.baseUrl}${ApiConstant.userProfile}");
      debugPrint("Data part: ${body['data']}");
      debugPrint("Has Image: ${selectedImage.value != null}");
      debugPrint("======================================");

      final response = await GetConnect().patch(
        "${ApiConstant.baseUrl}${ApiConstant.userProfile}",
        formData,
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(const Duration(seconds: 45)); // Longer timeout for file upload

      debugPrint("==== UPDATE RESPONSE ====");
      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        ToastHelper.showSuccess(
            response.body != null && response.body['message'] != null
                ? response.body['message']
                : "Profile updated successfully");
        await profileController.getUserProfile();
        Get.back();
      } else {
        String errorMsg =
            response.body != null && response.body['message'] != null
                ? response.body['message']
                : "Failed to update profile";
        ToastHelper.showError("Error (${response.statusCode}): $errorMsg");
      }
    } catch (e) {
      debugPrint("Full Update Error: $e");
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
