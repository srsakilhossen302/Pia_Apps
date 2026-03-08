import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Core/AppRoute/app_route.dart';
import '../../../../Model/Client_Section/subscription_model.dart';
import '../../../../helper/shared_prefe/shared_prefe.dart';
import '../../../../service/api_url.dart';

class ClientSubscriptionController extends GetxController {
  var isLoading = false.obs;
  var plans = <SubscriptionPlanModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getSubscriptionPlans();
  }

  Future<void> getSubscriptionPlans() async {
    isLoading.value = true;
    try {
      final token = await SharePrefsHelper.getString(SharedPreferenceValue.token);
      final response = await GetConnect().get(
        "${ApiConstant.baseUrl}${ApiConstant.subscriptionPlans}",
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List data = response.body['data'] ?? [];
        plans.value = data.map((json) => SubscriptionPlanModel.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint("Subscription Plans Load Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void selectPlan(SubscriptionPlanModel plan) {
    if (plan.price == 0) {
      Get.snackbar("Success", "Free plan activated");
      // Logic for free activation
    } else {
      // Navigate to payment for paid plans
      // Pass plan data to payment screen if needed
      Get.toNamed(AppRoute.clientPaymentScreen, arguments: plan);
    }
  }
}
