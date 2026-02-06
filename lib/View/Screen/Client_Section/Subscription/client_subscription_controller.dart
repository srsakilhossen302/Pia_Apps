import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Core/AppRoute/app_route.dart';
import '../../../../Model/Client_Section/subscription_model.dart';

class ClientSubscriptionController extends GetxController {
  final List<SubscriptionPlan> plans = [
    SubscriptionPlan(
      title: "FREE PLAN",
      price: "\$0.00",
      duration: "/mo",
      features: [
        "Unlimited recipe access",
        "Ad-free experience",
        "Advanced meal planning",
        "Priority support",
      ],
      buttonText: "Free Subscription",
      primaryColor: const Color(0xFFF48FB1), // Pink
    ),
    SubscriptionPlan(
      title: "YEARLY",
      price: "\$95.99",
      duration: "/yr",
      subtitle: "\$7.99/month",
      features: [
        "Everything in Monthly",
        "Exclusive recipes",
        "Nutritionist consultations",
        "Early access to features",
      ],
      buttonText: "Subscribe Yearly",
      primaryColor: const Color(0xFFFFA776), // Orange
      isRecommended: true,
      badgeText: "Save 20%",
    ),
    SubscriptionPlan(
      title: "MONTHLY",
      price: "\$9.99",
      duration: "/mo",
      features: [
        "Unlimited recipe access",
        "Ad-free experience",
        "Advanced meal planning",
        "Priority support",
      ],
      buttonText: "Subscribe Monthly",
      primaryColor: const Color(0xFFF48FB1), // Pink
    ),
  ];

  void selectPlan(SubscriptionPlan plan) {
    if (plan.title == "FREE PLAN") {
      // Direct activation or logic for free plan
      Get.snackbar("Success", "Free plan activated");
      // Get.offAllNamed(AppRoute.homeScreen);
    } else {
      // Navigate to payment for paid plans
      Get.toNamed(AppRoute.clientPaymentScreen);
    }
  }
}
