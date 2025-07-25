import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../data/remote/base/status.dart';
import '../../../data/remote/dto/job/job_out_dto.dart';
import '../../../data/remote/dto/position/position_out_dto.dart';
import '../../../data/remote/repositories/home/home_repository.dart';
import '../../../di/locator.dart';

class HomeController extends GetxController {
  final HomeRepository _repository = getIt.get<HomeRepository>();

  final _customerAvatar = const Status<String>.idle().obs;
  Status<String> get customerAvatar => _customerAvatar.value;

  final _featuredJobs = const Status<List<JobOutDto>>.idle().obs;
  Status<List<JobOutDto>> get featuredJobs => _featuredJobs.value;

  final _recentJobs = const Status<List<JobOutDto>>.idle().obs;
  Status<List<JobOutDto>> get recentJobs => _recentJobs.value;

  final _positions = const Status<List<PositionOutDto>>.idle().obs;
  Status<List<PositionOutDto>> get positions => _positions.value;

  // Properties for UI interaction that were missing
  final homeScrollController = ScrollController();
  final indicatorIndex = 0.obs;
  final chipTitle = "All".obs;

  void updateIndicatorValue(int index) => indicatorIndex.value = index;

  void updateChipTitle(String title) => chipTitle.value = title;

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    _customerAvatar.value = const Status.loading();
    _featuredJobs.value = const Status.loading();
    _recentJobs.value = const Status.loading();
    _positions.value = const Status.loading();
    await Future.wait([
      _getFeaturedJobs(),
      _getRecentJobs(),
      _getPositions(),
      _getCustomerAvatar(),
    ]);
  }

  Future<void> _getFeaturedJobs() async {
    try {
      final response = await _repository.getFeaturedJobs();
      final jobs = response.data?.jobs;
      if (jobs != null) {
        _featuredJobs.value = Status.success(data: jobs);
      } else {
        _featuredJobs.value =
            const Status.failure(reason: "No featured jobs found.");
      }
    } on DioException catch (e) {
      _featuredJobs.value = Status.failure(reason: e.message);
    } catch (e) {
      _featuredJobs.value = Status.failure(reason: e.toString());
    }
  }

  Future<void> _getRecentJobs() async {
    try {
      final response = await _repository.getRecentJobs();
      final jobs = response.data?.jobs;
      if (jobs != null) {
        _recentJobs.value = Status.success(data: jobs);
      } else {
        _recentJobs.value = const Status.failure(reason: "No recent jobs found.");
      }
    } on DioException catch (e) {
      _recentJobs.value = Status.failure(reason: e.message);
    } catch (e) {
      _recentJobs.value = Status.failure(reason: e.toString());
    }
  }

  Future<void> _getPositions() async {
    try {
      final response = await _repository.getPositions();
      final positions = response.data?.positions;
      if (positions != null) {
        _positions.value = Status.success(data: positions);
      } else {
        _positions.value = const Status.failure(reason: "No positions found.");
      }
    } on DioException catch (e) {
      _positions.value = Status.failure(reason: e.message);
    } catch (e) {
      _positions.value = Status.failure(reason: e.toString());
    }
  }

  Future<void> _getCustomerAvatar() async {
    try {
      final response = await _repository.getCustomerProfile();
      final avatarUrl = response.data?['data']?['avatar'];
      if (avatarUrl != null) {
        _customerAvatar.value = Status.success(data: avatarUrl);
      } else {
        _customerAvatar.value = const Status.failure(reason: "Avatar not found.");
      }
    } on DioException catch (e) {
      _customerAvatar.value = Status.failure(reason: e.message);
    } catch (e) {
      _customerAvatar.value = Status.failure(reason: e.toString());
    }
  }

  Future<void> onSaveButtonTapped(bool isSaved, String jobId) async {
    // TODO: Implement save/unsave job logic
    print("Job $jobId saved: ${!isSaved}");
  }
}