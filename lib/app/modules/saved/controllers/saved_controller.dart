import 'package:flutter/material.dart'; // Changed from cupertino to material for GlobalKey
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';

import '../../../data/remote/api/api_routes.dart';
import '../../../data/remote/base/status.dart' as base_status; // Ensure this Status class matches the one I provided earlier
import '../../../data/remote/dto/job/job_out_dto.dart' as job_dto;
import '../../../data/remote/repositories/customer/customer_repository.dart';
import '../../../di/locator.dart';
import '../../../widgets/custom_job_card.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../root/controllers/root_controller.dart';

class SavedController extends GetxController {
  static SavedController get to => Get.find();
  final _customerRepository = getIt.get<CustomerRepository>();
  final _rootController = Get.find<RootController>();
  final _authController = AuthController.to;
  final _savedScrollController = ScrollController();
  final animatedListKey = GlobalKey<AnimatedListState>();

  ScrollController get savedScrollController => _savedScrollController;

  // Initializing with Status.loading() or Status.success([]) if no initial data
  // Assuming Status.idle() is not part of the provided Status class.
  final Rx<base_status.Status<List<job_dto.JobOutDto>>> _rxSavedJobs =
      Rx<base_status.Status<List<job_dto.JobOutDto>>>(base_status.Status.loading()); // Changed to Status.loading()

  base_status.Status<List<job_dto.JobOutDto>> get savedJobs => _rxSavedJobs.value;

  @override
  void onReady() {
    super.onReady();
    getSavedJobs();
  }

  Future<void> jumpToHome() async {
    _rootController.persistentTabController.jumpToTab(0);
  }

  Future<void> getSavedJobs() async {
    _rxSavedJobs.value = base_status.Status.loading(); // Set to loading state
    // Ensure currentUser and its id are not null before accessing
    if (_authController.currentUser?.id == null) {
      _rxSavedJobs.value = base_status.Status.error(message: "User not authenticated.");
      return;
    }
    final result = await _customerRepository.getAllSavedJobs(
        customerId: _authController.currentUser!.id!); // Changed to correct parameter name
    // Convert Status<JobsOutDto> to Status<List<JobOutDto>>
    if (result.isSuccess && result.data != null) {
      _rxSavedJobs.value = base_status.Status.success((result.data!.jobs ?? []).cast<job_dto.JobOutDto>());
    } else if (result.isError) {
      _rxSavedJobs.value = base_status.Status.error(message: result.message);
    } else if (result.isLoading) {
      _rxSavedJobs.value = base_status.Status.loading();
    }
  }

  bool isJobSaved(String jobUuid) {
    // Safely access data only if the status is success
    if (savedJobs.isSuccess && savedJobs.data != null) {
      return savedJobs.data!.any((job) => job.id == jobUuid);
    }
    return false;
  }

  Future<bool?> onSaveButtonTapped(bool isSaved, String jobUuid) async {
    final result = await onSaveStateChange(isSaved, jobUuid);

    // Only proceed if the result of saving/unsaving was successful
    if (result != null && savedJobs.isSuccess && savedJobs.data != null) {
      final savedList = savedJobs.data!;
      final index = savedList.indexWhere((job) => job.id == jobUuid);

      if (index != -1) { // Check if the job exists in the list
        removeSavedJobFromAnimatedList(index);
        if (savedList.isEmpty) {
          getSavedJobs(); // Refresh if list becomes empty
        }
        HomeController.to.getFeaturedJobs();
        HomeController.to.getRecentJobs();
      }
    }
    return result;
  }

  Future<bool?> onSaveStateChange(bool isSaved, String jobUuid) async {
    // Ensure currentUser and its id are not null before accessing
    if (_authController.currentUser?.id == null) {
      Get.snackbar("Error", "User not authenticated for this action.");
      return null;
    }
    final result = await _customerRepository.toggleSave(
      _authController.currentUser!.id!,
      jobUuid: jobUuid,
    );

    // Safely get the 'saved' status from the result
    if (result.isSuccess && result.data is Map<String, dynamic> && (result.data as Map<String, dynamic>).containsKey('saved')) {
      return (result.data as Map<String, dynamic>)['saved'] as bool?;
    } else if (result.isError) {
      Get.snackbar("Error", result.message ?? "Failed to update save status.");
    }
    return null; // Return null if not successful or 'saved' status is not found
  }

  void animateToStart() {
    _savedScrollController.animateTo(0.0,
        duration: const Duration(seconds: 1), curve: Curves.easeOut);
  }

  void onRetry() {
    getSavedJobs();
  }

  void removeSavedJobFromAnimatedList(int index) {
    if (savedJobs.isSuccess && savedJobs.data != null && index >= 0 && index < savedJobs.data!.length) {
      final item = savedJobs.data![index];
      savedJobs.data!.removeAt(index); // Remove from the underlying list
      animatedListKey.currentState!.removeItem(index, (context, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: CustomJobCard(
            // Apply null-safe access here as well
            avatar: "${ApiRoutes.BASE_URL}${item.company?.image ?? 'placeholder.png'}",
            companyName: item.company?.name ?? '',
            employmentType: item.employmentType ?? '',
            jobPosition: item.position ?? '',
            location: item.location ?? '',
            actionIcon: HeroIcons.bookmark,
            publishTime: item.createdAt?.toIso8601String() ?? '',
            workplace: item.workplace ?? '',
            description: item.description ?? '',
            // onTap and onActionTap are not needed for the removed item's animation
          ),
        );
      });
    }
  }
}
