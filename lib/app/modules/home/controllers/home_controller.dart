import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/remote/base/status.dart';
import '../../../data/remote/dto/choices/Position_out_dto.dart';
import '../../../data/remote/dto/job/job_out_dto.dart';
import '../../../data/remote/repositories/customer/customer_repository.dart';
import '../../../data/remote/repositories/job/job_repository.dart';
import '../../../data/remote/repositories/position/position_repository.dart';
import '../../../di/locator.dart';
import '../../../widgets/dialogs.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../saved/controllers/saved_controller.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();
  final _jobRepository = getIt.get<JobRepository>();
  final _positionRepository = getIt.get<PositionRepository>();
  final _customerRepository = getIt.get<CustomerRepository>();
  final _homeScrollController = ScrollController();

  ScrollController get homeScrollController => _homeScrollController;

  final RxInt _indicatorIndex = 0.obs;

  int get indicatorIndex => _indicatorIndex.value;

  final RxString _rxChipTitle = RxString("All");

  String? get chipTitle => _rxChipTitle.value;

  final Rx<Status<List<JobOutDto>>> _rxRecentJobs =
      Rx<Status<List<JobOutDto>>>(const Status.loading());

  Status<List<JobOutDto>> get recentJobs => _rxRecentJobs.value;

  final Rx<Status<List<JobOutDto>>> _rxFeaturedJobs =
      Rx<Status<List<JobOutDto>>>(const Status.loading());

  Status<List<JobOutDto>> get featuredJobs => _rxFeaturedJobs.value;

  final Rx<Status<List<PositionOutDto>>> _rxPositions =
      Rx<Status<List<PositionOutDto>>>(const Status.loading());

  Status<List<PositionOutDto>> get positions => _rxPositions.value;

  final Rx<Status<String>> _rxCustomerAvatar =
      Rx<Status<String>>(const Status.loading());

  Status<String> get customerAvatar => _rxCustomerAvatar.value;

  @override
  void onInit() {
    super.onInit();
    _loadHome();
  }



  void updateChipTitle(String title) {
    if (chipTitle != title) {
      _rxChipTitle.value = title;
      getRecentJobs();
    }
  }

  updateIndicatorValue(newIndex, _) {
    _indicatorIndex.value = newIndex;
  }

  Future<void> getFeaturedJobs() async {
    _rxFeaturedJobs.value = const Status.loading();
    final Status<List<JobOutDto>> state =
        await _jobRepository.getAll(isFeatured: true);
    _rxFeaturedJobs.value = state;
  }

  Future<void> getRecentJobs() async {
    _rxRecentJobs.value = const Status.loading();
    final Status<List<JobOutDto>> state = await _jobRepository.getAll(
      position: chipTitle == "All" ? null : chipTitle,
      isFeatured: false,
    );
    _rxRecentJobs.value = state;
  }

  Future<void> getPositions() async {
    final Status<List<PositionOutDto>> state =
        await _positionRepository.getAll();
    _rxPositions.value = state;
    _insertAllPosition();
  }

  _insertAllPosition() {
    final allPosition = PositionOutDto(jobTitle: "All");
    final positionsList = positions.whenOrNull(success: (data) => data!);
    if (positionsList != null && !positionsList.contains(allPosition)) {
      positionsList.insert(0, allPosition);
      _rxPositions.value = Status.success(data: positionsList);
    }
  }

  void animateToStart() {
    _homeScrollController.animateTo(0.0,
        duration: const Duration(seconds: 1), curve: Curves.easeOut);
  }

  Future<bool?> onSaveButtonTapped(bool isSaved, String jobUuid) async {
    final result = await SavedController.to.onSaveStateChange(isSaved, jobUuid);
    if (result != null) SavedController.to.getSavedJobs();
    return result;
  }

  void _loadHome() async {
    await getCustomerAvatar();
    await getPositions();
    await getFeaturedJobs();
    await getRecentJobs();
    showDialogOnFailure();
  }

  void _onRetry() async {
    if (positions is Failure) {
      await getPositions();
      showDialogOnFailure();
    } else if (featuredJobs is Failure) {
      await getFeaturedJobs();
      showDialogOnFailure();
    } else if (recentJobs is Failure) {
      await getRecentJobs();
      showDialogOnFailure();
    }
  }

  void showDialogOnFailure() {
    if (positions is Failure) {
      _getErrDialog((positions as Failure).reason!);
    } else if (featuredJobs is Failure) {
      _getErrDialog((featuredJobs as Failure).reason!);
    } else if (recentJobs is Failure) {
      _getErrDialog((recentJobs as Failure).reason!);
    }
  }

  void _getErrDialog(String msg) {
    if (Get.isDialogOpen!) return;
    Dialogs.spaceDialog(
      description: msg,
      dismissOnBackKeyPress: false,
      dismissOnTouchOutside: false,
      btnOkOnPress: () {
        Get.back();
        _onRetry();
      },
    );
  }

  Future<void> getCustomerAvatar() async {
    final Status<String> state = await _customerRepository.getAvatar(
      customerUuid: AuthController.to.currentUser!.id!,
    );
    if (state is Success) _rxCustomerAvatar.value = state;
  }
}
