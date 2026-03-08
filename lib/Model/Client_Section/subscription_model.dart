import 'package:flutter/material.dart';

class SubscriptionPlanModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String currency;
  final String interval;
  final int intervalCount;
  final int trialPeriodDays;
  final List<String> features;
  final int maxTeamMembers;
  final int maxServices;
  final bool isActive;
  final String stripePriceId;
  final String stripeProductId;
  final List<String> userTypes;
  final int priority;

  SubscriptionPlanModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.currency,
    required this.interval,
    required this.intervalCount,
    required this.trialPeriodDays,
    required this.features,
    required this.maxTeamMembers,
    required this.maxServices,
    required this.isActive,
    required this.stripePriceId,
    required this.stripeProductId,
    required this.userTypes,
    required this.priority,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'usd',
      interval: json['interval'] ?? 'month',
      intervalCount: json['intervalCount'] ?? 1,
      trialPeriodDays: json['trialPeriodDays'] ?? 0,
      features: List<String>.from(json['features'] ?? []),
      maxTeamMembers: json['maxTeamMembers'] ?? 1,
      maxServices: json['maxServices'] ?? 0,
      isActive: json['isActive'] ?? false,
      stripePriceId: json['stripePriceId'] ?? '',
      stripeProductId: json['stripeProductId'] ?? '',
      userTypes: List<String>.from(json['userTypes'] ?? []),
      priority: json['priority'] ?? 0,
    );
  }

  // Display helpers for UI
  String get formattedPrice => "${currency.toUpperCase()} $price";
  String get formattedInterval => interval == 'month' ? '/mo' : '/yr';
  
  Color get primaryColor {
    if (name.contains("Professional Starter")) return const Color(0xFFF48FB1); // Pink
    if (name.contains("Professional Pro")) return const Color(0xFFFFA776); // Orange
    return const Color(0xFFF48FB1); // Default
  }
}
