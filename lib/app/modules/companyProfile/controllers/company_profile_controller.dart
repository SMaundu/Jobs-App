import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/remote/base/status.dart'; // Ensure this points to your standard Status class
import '../../../data/remote/dto/company/Company_out_dto.dart' as company_dto; // Added 'as company_dto'
import '../../../data/remote/dto/job/job_out_dto.dart' hide CompanyOutDto; // Added 'hide CompanyOutDto'
import '../../../data/remote/repositories/company/company_repository.dart';
import '../../../data/remote/repositories/job/job_repository.dart';
import '../../../di/locator.dart';
import '../../../widgets/dialogs.dart';
import '../../saved/controllers/saved_controller.dart';

class CompanyProfileController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final _companyRepository = getIt.get<CompanyRepository>();
  final _jobsRepository = getIt.get<JobRepository>();

  final String uuid = Get.arguments;
  late TabController tabController;

  final Rx<Status<company_dto.CompanyOutDto>> _rxCompany = // Used 'company_dto.CompanyOutDto'
      Rx<Status<company_dto.CompanyOutDto>>(Status.loading()); // Used 'company_dto.CompanyOutDto'

  Status<company_dto.CompanyOutDto> get rxCompany => _rxCompany.value; // Used 'company_dto.CompanyOutDto'

  final Rx<Status<List<JobOutDto>>> _rxJobs =
      Rx<Status<List<JobOutDto>>>(Status.loading());

  Status<List<JobOutDto>> get rxJobs => _rxJobs.value;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    loadPage();
  }

  getCompany() async {
    Status<company_dto.CompanyOutDto> state = await _companyRepository.get(uuid: uuid); // Used 'company_dto.CompanyOutDto'
    _rxCompany.value = state;
  }

  getCompanyJobs() async {
    final Status<List<JobOutDto>> jobs =
        await _jobsRepository.getAll(companyId: uuid);
    _rxJobs.value = jobs;
  }

  Future<bool?> onSaveButtonTapped(bool isSaved, String jobUuid) async {
    final result = await SavedController.to.onSaveStateChange(isSaved, jobUuid);
    if (result != null) SavedController.to.getSavedJobs();
    return result;
  }

  void loadPage() async {
    await getCompany();
    await getCompanyJobs();
    showDialogOnFailure();
  }

  void onRetry() async {
    _rxCompany.value = Status.loading();
    await getCompany();
    await getCompanyJobs();
    showDialogOnFailure();
  }

  void showDialogOnFailure() {
    // Corrected to use the isError getter from the standard Status class
    if (rxCompany.isError) {
      Dialogs.spaceDialog(
        // Access the message property directly from the Status object
        description: rxCompany.message ?? "An unknown error occurred.",
        btnOkOnPress: onRetry,
        dismissOnBackKeyPress: false,
        dismissOnTouchOutside: false,
      );
    }
  }
}
