import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart'; // Import for CarouselPageChangedReason

import '../../../data/remote/base/status.dart';
import '../../../data/remote/dto/job/job_out_dto.dart';
import '../../../data/remote/dto/position/position_out_dto.dart';
import '../../../data/remote/repositories/home/home_repository.dart';
import '../../../di/locator.dart';
import '../../auth/controllers/auth_controller.dart'; // Import AuthController for currentUser

class HomeController extends GetxController {
  static HomeController get to => Get.find();

  final HomeRepository _repository = getIt.get<HomeRepository>();

  // Correctly initialize Rx<Status> with a named constructor
  final _customerAvatar = Status<String>.loading().obs;
  Status<String> get customerAvatar => _customerAvatar.value;

  final _featuredJobs = Status<List<JobOutDto>>.loading().obs;
  Status<List<JobOutDto>> get featuredJobs => _featuredJobs.value;

  final _recentJobs = Status<List<JobOutDto>>.loading().obs;
  Status<List<JobOutDto>> get recentJobs => _recentJobs.value;

  final _positions = Status<List<PositionOutDto>>.loading().obs;
  Status<List<PositionOutDto>> get positions => _positions.value;

  // Properties for UI interaction
  final homeScrollController = ScrollController();
  final indicatorIndex = 0.obs;
  final chipTitle = "All".obs;

  // Corrected signature to match CarouselPageChangedReason
  void updateIndicatorValue(int index, CarouselPageChangedReason reason) =>
      indicatorIndex.value = index;

  void updateChipTitle(String title) => chipTitle.value = title;

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    // Set all statuses to loading before fetching
    _customerAvatar.value = Status.loading();
    _featuredJobs.value = Status.loading();
    _recentJobs.value = Status.loading();
    _positions.value = Status.loading();
    await Future.wait([
      getFeaturedJobs(),
      getRecentJobs(),
      _getPositions(),
      _getCustomerAvatar(),
    ]);
  }

  Future<void> getFeaturedJobs() async {
    try {
      final response = await _repository.getFeaturedJobs();
      // Access data safely from Status object
      if (response.isSuccess && response.data != null && response.data!.jobs != null) {
        _featuredJobs.value = Status.success(response.data!.jobs!);
      } else {
        // Use Status.error with message parameter
        _featuredJobs.value = Status.error(message: "No featured jobs found.");
      }
    } on DioException catch (e) {
      _featuredJobs.value = Status.error(message: e.message);
    } catch (e) {
      _featuredJobs.value = Status.error(message: e.toString());
    }
  }

  Future<void> getRecentJobs() async {
    try {
      final response = await _repository.getRecentJobs();
      // Access data safely from Status object
      if (response.isSuccess && response.data != null && response.data!.jobs != null) {
        _recentJobs.value = Status.success(response.data!.jobs!);
      } else {
        // Use Status.error with message parameter
        _recentJobs.value = Status.error(message: "No recent jobs found.");
      }
    } on DioException catch (e) {
      _recentJobs.value = Status.error(message: e.message);
    } catch (e) {
      _recentJobs.value = Status.error(message: e.toString());
    }
  }

  Future<void> _getPositions() async {
    try {
      final response = await _repository.getPositions();
      // Access data safely from Status object
      // Changed from response.data!.positions to response.data!
      if (response.isSuccess && response.data != null) {
        _positions.value = Status.success(response.data!);
      } else {
        // Use Status.error with message parameter
        _positions.value = Status.error(message: "No positions found.");
      }
    } on DioException catch (e) {
      _positions.value = Status.error(message: e.message);
    } catch (e) {
      _positions.value = Status.error(message: e.toString());
    }
  }

  Future<void> _getCustomerAvatar() async {
    try {
      // Ensure currentUser and its id are not null before accessing
      final customerId = AuthController.to.currentUser?.id;
      if (customerId == null) {
        _customerAvatar.value = Status.error(message: "User not authenticated.");
        return;
      }

      final response = await _repository.getCustomerProfile(customerUuid: customerId);
      // Access data safely from Status object
      if (response.isSuccess && response.data != null && response.data!.avatar != null) {
        _customerAvatar.value = Status.success(response.data!.avatar!);
      } else {
        // Use Status.error with message parameter
        _customerAvatar.value = Status.error(message: "Avatar not found.");
      }
    } on DioException catch (e) {
      _customerAvatar.value = Status.error(message: e.message);
    } catch (e) {
      _customerAvatar.value = Status.error(message: e.toString());
    }
  }

  // Changed return type to Future<bool?> as expected by the UI.
  // The actual logic for saving/unsaving should return true/false based on success.
  Future<bool?> onSaveButtonTapped(bool isSaved, String jobId) async {
    // TODO: Implement actual save/unsave job logic here
    print("Job $jobId saved: ${!isSaved}");
    // For demonstration, let's assume it always succeeds and toggles the state
    return !isSaved;
  }

  void animateToStart() {
    if (homeScrollController.hasClients) {
      homeScrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }
}
