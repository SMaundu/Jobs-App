import 'package:get/get.dart';

import '../../../data/remote/base/status.dart';
import '../../../data/remote/dto/customer/customer_profile_out_dto.dart';
import '../../../data/remote/repositories/customer/customer_repository.dart';
import '../../../di/locator.dart';
import '../../../widgets/dialogs.dart';
import '../../auth/controllers/auth_controller.dart';

class CustomerProfileController extends GetxController {
  final customerRepository = getIt.get<CustomerRepository>();

  final Rx<Status<CustomerProfileOutDto>> _rxProfile =
      Rx(Status.loading());

  Status<CustomerProfileOutDto> get profile => _rxProfile.value;

  @override
  void onInit() {
    super.onInit();
    loadPage();
  }

  getProfile() async {
    // Ensure currentUser and its id are not null before accessing
    if (AuthController.to.currentUser?.id == null) {
      _rxProfile.value = Status.error(message: "User not authenticated.");
      return;
    }
    final state = await customerRepository.getProfile(
        customerUuid: AuthController.to.currentUser!.id!);
    _rxProfile.value = state;
  }

  void loadPage() async {
    await getProfile();
    showDialogOnFailure();
  }

  void onRetry() async {
    _rxProfile.value = Status.loading(); // Changed to non-const Status.loading()
    await getProfile();
    showDialogOnFailure();
  }

  void showDialogOnFailure() {
    // Changed 'profile is Failure' to 'profile.isError'
    if (profile.isError) {
      Dialogs.spaceDialog(
        // Access message from the Status object
        description: profile.message ?? "An unknown error occurred.",
        btnOkOnPress: onRetry,
        dismissOnBackKeyPress: false,
        dismissOnTouchOutside: false,
      );
    }
  }
}
