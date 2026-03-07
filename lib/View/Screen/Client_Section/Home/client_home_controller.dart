import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Model/Client_Section/cycle_overview_model.dart';
import '../../../../helper/shared_prefe/shared_prefe.dart';
import '../../../../helper/toast_helper.dart';
import '../../../../service/api_url.dart';

class ClientHomeController extends GetxController {
  final RxInt currentIndex = 0.obs;
  late PageController pageController;

  final Rx<CycleOverviewData?> cycleOverview = Rx<CycleOverviewData?>(null);
  final RxBool isLoadingCycle = false.obs;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(viewportFraction: 1.0);
    getCycleOverview();
  }

  Future<void> getCycleOverview({String? phase}) async {
    isLoadingCycle.value = true;
    update();
    try {
      final token = await SharePrefsHelper.getString(
        SharedPreferenceValue.token,
      );
      
      String url = "${ApiConstant.baseUrl}${ApiConstant.cycleOverview}";
      if (phase != null) {
        url += "?phase=$phase";
      }

      final response = await GetConnect().get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final cycleResponse = CycleOverviewResponse.fromJson(response.body);
        
        // Always store the initial data first so UI populates
        if (phase == null) {
          cycleOverview.value = cycleResponse.data;
        }

        bool isRecEmpty = cycleResponse.data?.recipes == null || 
                          cycleResponse.data!.recipes!.isEmpty || 
                          cycleResponse.data!.recipes!.values.every((list) => list.isEmpty);
        bool hasRecipes = !isRecEmpty;
        
        if (phase == null && cycleResponse.data != null && !hasRecipes) {
            bool isComplete = cycleResponse.data!.currentPhaseInfo?.isHealthSetupComplete == true;
            String? phaseToQuery;
            if (isComplete) {
                phaseToQuery = cycleResponse.data!.currentPhaseInfo?.phase;
            } else {
                if (cycleResponse.data!.educationalContent != null && cycleResponse.data!.educationalContent!.isNotEmpty) {
                    phaseToQuery = cycleResponse.data!.educationalContent![0].phase;
                }
            }
            if (phaseToQuery != null && phaseToQuery.isNotEmpty) {
                await _fetchCycleOverviewWithPhase(phaseToQuery, token);
                return;
            }
        }
        
        if (phase != null) {
          cycleOverview.value = cycleResponse.data;
        }
        if (phase != null && cycleOverview.value?.educationalContent != null) {
           int idx = cycleOverview.value!.educationalContent!.indexWhere((e) => e.phase?.toLowerCase() == phase.toLowerCase());
           if (idx != -1) {
              currentIndex.value = idx;
           }
        }
      } else {
        String msg = "Failed to load cycle overview: ${response.statusCode}";
        if (response.body != null) {
          msg += " Body: ${response.body}";
        }
        ToastHelper.showError(msg);
      }
    } catch (e) {
      ToastHelper.showError("Network error: $e");
    } finally {
      isLoadingCycle.value = false;
      update();
    }
  }

  Future<void> _fetchCycleOverviewWithPhase(String phase, String token) async {
      String url = "${ApiConstant.baseUrl}${ApiConstant.cycleOverview}?phase=$phase";
      try {
        final response = await GetConnect().get(
            url,
            headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
            },
        );
        if (response.statusCode == 200) {
            final cycleResponse = CycleOverviewResponse.fromJson(response.body);
            cycleOverview.value = cycleResponse.data;
            if (cycleOverview.value?.educationalContent != null) {
                int idx = cycleOverview.value!.educationalContent!.indexWhere((e) => e.phase?.toLowerCase() == phase.toLowerCase());
                if (idx != -1) {
                   currentIndex.value = idx;
                }
            }
        } else {
            String msg = "Failed to load cycle overview: ${response.statusCode}";
            if (response.body != null) {
                msg += " Body: ${response.body}";
            }
            ToastHelper.showError(msg);
        }
      } catch (e) {
        ToastHelper.showError("Network error: $e");
      } finally {
        isLoadingCycle.value = false;
        update();
      }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void nextPage() {
    if (cycleOverview.value?.educationalContent != null) {
        if (currentIndex.value < cycleOverview.value!.educationalContent!.length - 1) {
          pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
    }
  }

  void previousPage() {
    if (currentIndex.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
