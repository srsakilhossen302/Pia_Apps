import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import '../../../../Model/Client_Section/subscription_model.dart';
import '../../../../helper/shared_prefe/shared_prefe.dart';
import '../../../../service/api_url.dart';

class ClientSubscriptionController extends GetxController {
  var isLoading = false.obs;
  var isProcessingPayment = false.obs;
  var plans = <SubscriptionPlanModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getSubscriptionPlans();
  }

  // ─── Step 1: Fetch available subscription plans ───────────────
  Future<void> getSubscriptionPlans() async {
    isLoading.value = true;
    try {
      final token =
          await SharePrefsHelper.getString(SharedPreferenceValue.token);
      final response = await GetConnect().get(
        "${ApiConstant.baseUrl}${ApiConstant.subscriptionPlans}",
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List data = response.body['data'] ?? [];
        plans.value =
            data.map((json) => SubscriptionPlanModel.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint("Subscription Plans Load Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ─── When user taps a plan ────────────────────────────────────
  void selectPlan(SubscriptionPlanModel plan) {
    if (plan.price == 0) {
      _activateFreePlan(plan);
    } else {
      _startSubscription(plan);
    }
  }

  // ─── Free plan activation ─────────────────────────────────────
  void _activateFreePlan(SubscriptionPlanModel plan) {
    Get.snackbar(
      "Success",
      "Free plan activated!",
      backgroundColor: const Color(0xFFE8F5E9),
      colorText: const Color(0xFF2E7D32),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  // ─── Step 2: Create subscription → get clientSecret ───────────
  Future<void> _startSubscription(SubscriptionPlanModel plan) async {
    isProcessingPayment.value = true;

    try {
      final token =
          await SharePrefsHelper.getString(SharedPreferenceValue.token);

      // Call backend to create subscription
      final response = await GetConnect().post(
        "${ApiConstant.baseUrl}${ApiConstant.subscriptionCreate}",
        {'planId': plan.id},
        headers: {
          'Authorization': 'Bearer $token',
        },
        contentType: 'application/json',
      );

      debugPrint("=== Subscription Create Response ===");
      debugPrint("Status: ${response.statusCode}");
      debugPrint("Body: ${response.body}");
      debugPrint("====================================");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body;
        final clientSecret = data['data']?['clientSecret'] ?? data['clientSecret'];

        if (clientSecret != null && clientSecret.toString().isNotEmpty) {
          // Step 3: Initialize & Present Payment Sheet
          await _initAndPresentPaymentSheet(clientSecret.toString());
        } else {
          _showError("Could not retrieve payment details. Please try again.");
        }
      } else {
        final message = response.body?['message'] ?? 'Failed to create subscription (${response.statusCode})';
        _showError(message.toString());
      }
    } catch (e) {
      debugPrint("Create Subscription Error: $e");
      _showError("Something went wrong. Please try again.");
    } finally {
      isProcessingPayment.value = false;
    }
  }

  // ─── Step 3: Init & Present Stripe Payment Sheet ──────────────
  Future<void> _initAndPresentPaymentSheet(String clientSecret) async {
    try {
      // Determine if it's a SetupIntent or PaymentIntent
      final bool isSetupIntent = clientSecret.startsWith('seti_');

      // 1. Initialize Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Use the correct parameter based on the clientSecret type
          setupIntentClientSecret: isSetupIntent ? clientSecret : null,
          paymentIntentClientSecret: !isSetupIntent ? clientSecret : null,
          merchantDisplayName: 'Ascela Health',
          style: ThemeMode.light,
        ),
      );

      // 2. Present Payment Sheet
      await Stripe.instance.presentPaymentSheet();

      // 3. Payment Success! — Verify status after a short delay
      //    (webhooks may take a moment to process)
      _showSuccess("Payment successful! Verifying your subscription...");

      // Wait a few seconds for webhook processing, then verify
      await Future.delayed(const Duration(seconds: 3));
      await _verifySubscriptionStatus();
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        // User cancelled — no error needed
        debugPrint("Payment cancelled by user");
      } else {
        _showError(e.error.localizedMessage ?? "Payment failed. Please try again.");
      }
    } catch (e) {
      debugPrint("Payment Sheet Error: $e");
      _showError("Payment failed. Please try again.");
    }
  }

  // ─── Step 4: Verify subscription status ───────────────────────
  Future<void> _verifySubscriptionStatus() async {
    try {
      final token =
          await SharePrefsHelper.getString(SharedPreferenceValue.token);

      final response = await GetConnect().get(
        "${ApiConstant.baseUrl}${ApiConstant.subscriptionStatus}",
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = response.body;
        final bool isActive = data['data']?['isActive'] ?? false;

        if (isActive) {
          Get.snackbar(
            "🎉 Welcome to Premium!",
            "Your subscription is now active. Enjoy all premium features!",
            backgroundColor: const Color(0xFFE8F5E9),
            colorText: const Color(0xFF2E7D32),
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(16),
            borderRadius: 12,
            duration: const Duration(seconds: 4),
          );
          // Navigate back or to home screen
          Get.back();
        } else {
          // Subscription not yet active — may still be processing
          Get.snackbar(
            "Processing",
            "Your payment is being processed. It may take a moment.",
            backgroundColor: const Color(0xFFFFF3E0),
            colorText: const Color(0xFFE65100),
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(16),
            borderRadius: 12,
            duration: const Duration(seconds: 4),
          );
        }
      }
    } catch (e) {
      debugPrint("Verify Status Error: $e");
    }
  }

  // ─── Helper: Show error snackbar ──────────────────────────────
  void _showError(String message) {
    Get.snackbar(
      "Error",
      message,
      backgroundColor: const Color(0xFFFFEBEE),
      colorText: const Color(0xFFC62828),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
    );
  }

  // ─── Helper: Show success snackbar ────────────────────────────
  void _showSuccess(String message) {
    Get.snackbar(
      "Success",
      message,
      backgroundColor: const Color(0xFFE8F5E9),
      colorText: const Color(0xFF2E7D32),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }
}
