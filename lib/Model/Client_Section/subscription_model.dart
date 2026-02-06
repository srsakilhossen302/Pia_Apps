import 'package:flutter/material.dart';

class SubscriptionPlan {
  final String title;
  final String price;
  final String duration;
  final String? subtitle;
  final List<String> features;
  final String buttonText;
  final Color primaryColor;
  final bool isRecommended;
  final String? badgeText;

  SubscriptionPlan({
    required this.title,
    required this.price,
    required this.duration,
    this.subtitle,
    required this.features,
    required this.buttonText,
    required this.primaryColor,
    this.isRecommended = false,
    this.badgeText,
  });
}
