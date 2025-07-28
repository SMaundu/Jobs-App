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
      Rx<Status<JobOutDto>>(Status.loading()); // Changed to non-const

  Status<JobOutDto> get job => _rxJob.value;

  final Rx<Status<List<JobOutDto>>> _rxSimilarJobs =
      Rx<Status<List<JobOutDto>>>(Status.loading()); // Changed to non-const

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
    // Ensure currentUser and its id are not null before accessing
    if (AuthController.to.currentUser?.id == null) {
      SnackBars.failure("Error", "User not authenticated for this action.");
      return;
    }

    final result = await _applicationRepository.create(
      dto: ApplicationInDto(
        customerId: AuthController.to.currentUser!.id,
        jobId: jobId,
        whyApply: whyApply,
      ),
    );
    // Using isSuccess and isError getters
    if (result.isSuccess) {
      FocusManager.instance.primaryFocus?.unfocus();
      Get.back();
      popupBottomSheet(bottomSheetBody: const SubmitBottomSheet());
    } else if (result.isError) {
      SnackBars.failure("Oops!", result.message ?? "An unknown error occurred.");
    }
  }

  Future<void> getSimilarJobs() async {
    // Using isSuccess getter
    if (job.isSuccess) {
      final data = job.data;
      if (data != null && data.position != null) {
        final jobs = await _jobRepository.getAll(position: data.position);
        // Using isSuccess getter
        if (jobs.isSuccess && jobs.data != null) {
          jobs.data!.removeWhere((element) => element.id == uuid);
        }
        _rxSimilarJobs.value = jobs;
      } else {
        _rxSimilarJobs.value = Status.error(message: "Job position not available for similar jobs.");
      }
    } else if (job.isError) {
      _rxSimilarJobs.value = Status.error(message: job.message ?? "Failed to load job details for similar jobs.");
    } else {
      _rxSimilarJobs.value = Status.loading(); // Keep loading if job details are not yet loaded
    }
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
    _rxJob.value = Status.loading(); // Changed to non-const
    await getJobDetails();
    showDialogOnFailure();
  }

  void showDialogOnFailure() {
    // Using isError getter
    if (job.isError) {
      Dialogs.spaceDialog(
        description: job.message ?? "An unknown error occurred.",
        btnOkOnPress: onRetry,
        dismissOnBackKeyPress: false,
        dismissOnTouchOutside: false,
      );
    }
  }
}
