import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/remote/base/status.dart';
import '../../../data/remote/dto/application/application_in_dto.dart';
import '../../../data/remote/dto/job/job_out_dto.dart';
import '../../../data/remote/repositories/application/application_repository.dart';
import '../../../data/remote/repositories/job/job_repository.dart';
import '../../../di/locator.dart';
import '../../../utils/functions.dart';
import '../../../widgets/dialogs.dart';
import '../../../widgets/snackbars.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../saved/controllers/saved_controller.dart';
import '../views/widgets/submit_bottom_sheet.dart';

class JobDetailsController extends GetxController {
  final String uuid = Get.arguments;
  final _jobRepository = getIt.get<JobRepository>();
  final _applicationRepository = getIt.get<ApplicationRepository>();

  final Rx<Status<JobOutDto>> _rxJob =
      Rx<Status<JobOutDto>>(const Status.loading());

  Status<JobOutDto> get job => _rxJob.value;

  final Rx<Status<List<JobOutDto>>> _rxSimilarJobs =
      Rx<Status<List<JobOutDto>>>(const Status.loading());

  Status<List<JobOutDto>> get similarJobs => _rxSimilarJobs.value;

  @override
  void onInit() {
    super.onInit();
    loadPage();
  }



  Future<void> getJobDetails() async {
    final Status<JobOutDto> state = await _jobRepository.get(uuid: uuid);
    _rxJob.value = state;
    getSimilarJobs();
  }

  Future<void> applyToJob(String jobId, String whyApply) async {
    final result = await _applicationRepository.create(
      dto: ApplicationInDto(
        customerId: AuthController.to.currentUser!.id,
        jobId: jobId,
        whyApply: whyApply,
      ),
    );
    result.whenOrNull(
      success: (data) {
        FocusManager.instance.primaryFocus?.unfocus();
        Get.back();
        popupBottomSheet(bottomSheetBody: const SubmitBottomSheet());
      },
      failure: (e) => SnackBars.failure("Oops!", e.toString()),
    );
  }

  Future<void> getSimilarJobs() async {
    job.whenOrNull(success: (data) async {
      final jobs = await _jobRepository.getAll(position: data!.position);
      jobs.whenOrNull(
          success: (data) =>
              data!.removeWhere((element) => element.id == uuid));
      _rxSimilarJobs.value = jobs;
    });
  }

  Future<bool?> onSaveButtonTapped(bool isSaved, String jobUuid) async {
    final result = await SavedController.to.onSaveStateChange(isSaved, jobUuid);
    if (result != null) {
      HomeController.to.getFeaturedJobs();
      HomeController.to.getRecentJobs();
    }
    return result;
  }

  void loadPage() async {
    await getJobDetails();
    showDialogOnFailure();
  }

  void onRetry() async {
    _rxJob.value = const Status.loading();
    await getJobDetails();
    showDialogOnFailure();
  }

  void showDialogOnFailure() {
    if (job is Failure) {
      Dialogs.spaceDialog(
        description: (job as Failure).reason.toString(),
        btnOkOnPress: onRetry,
        dismissOnBackKeyPress: false,
        dismissOnTouchOutside: false,
      );
    }
  }
}
