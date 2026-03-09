import 'subscription_model.dart';
import 'package:intl/intl.dart';

class MySubscriptionModel {
  final String id;
  final String userId;
  final SubscriptionPlanModel plan;
  final String stripeCustomerId;
  final String stripeSubscriptionId;
  final String status;
  final DateTime? currentPeriodStart;
  final DateTime? currentPeriodEnd;
  final DateTime? trialStart;
  final DateTime? trialEnd;
  final bool cancelAtPeriodEnd;
  final bool hasUsedTrial;

  MySubscriptionModel({
    required this.id,
    required this.userId,
    required this.plan,
    required this.stripeCustomerId,
    required this.stripeSubscriptionId,
    required this.status,
    this.currentPeriodStart,
    this.currentPeriodEnd,
    this.trialStart,
    this.trialEnd,
    required this.cancelAtPeriodEnd,
    required this.hasUsedTrial,
  });

  factory MySubscriptionModel.fromJson(Map<String, dynamic> json) {
    return MySubscriptionModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      plan: SubscriptionPlanModel.fromJson(json['planId'] ?? {}),
      stripeCustomerId: json['stripeCustomerId'] ?? '',
      stripeSubscriptionId: json['stripeSubscriptionId'] ?? '',
      status: json['status'] ?? 'unknown',
      currentPeriodStart: json['currentPeriodStart'] != null ? DateTime.tryParse(json['currentPeriodStart'])?.toLocal() : null,
      currentPeriodEnd: json['currentPeriodEnd'] != null ? DateTime.tryParse(json['currentPeriodEnd'])?.toLocal() : null,
      trialStart: json['trialStart'] != null ? DateTime.tryParse(json['trialStart'])?.toLocal() : null,
      trialEnd: json['trialEnd'] != null ? DateTime.tryParse(json['trialEnd'])?.toLocal() : null,
      cancelAtPeriodEnd: json['cancelAtPeriodEnd'] ?? false,
      hasUsedTrial: json['hasUsedTrial'] ?? false,
    );
  }

  bool get isActive {
    // If status is active or trialing, and end date hasn't passed
    if (status != 'active' && status != 'trialing') return false;
    if (currentPeriodEnd == null) return false;
    return currentPeriodEnd!.isAfter(DateTime.now());
  }

  bool get isTrialing => status == 'trialing';

  String get formattedStartDate {
    if (currentPeriodStart == null) return "N/A";
    return DateFormat('dd MMM yyyy').format(currentPeriodStart!);
  }

  String get formattedEndDate {
    if (currentPeriodEnd == null) return "N/A";
    return DateFormat('dd MMM yyyy').format(currentPeriodEnd!);
  }
}
