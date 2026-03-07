import 'cycle_overview_model.dart';

class PhaseDetailResponse {
  final int? statusCode;
  final bool? success;
  final String? message;
  final CurrentPhaseInfo? data;

  PhaseDetailResponse({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory PhaseDetailResponse.fromJson(Map<String, dynamic> json) {
    return PhaseDetailResponse(
      statusCode: json['statusCode'],
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? CurrentPhaseInfo.fromJson(json['data']) : null,
    );
  }
}
