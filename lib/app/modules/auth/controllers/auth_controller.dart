import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/countries.dart';

import '../../../data/local/entities/user_entity.dart';
import '../../../data/remote/base/status.dart';
// Removed: import '../../../data/remote/base/status.freezed.dart'; // Not needed for non-freezed Status class
import '../../../data/remote/dto/auth/login_in_dto.dart';
import '../../../data/remote/dto/auth/login_out_dto.dart';
import '../../../data/remote/dto/auth/register_company_dto.dart';
import '../../../data/remote/dto/auth/register_company_out_dto.dart';
import '../../../data/remote/dto/auth/register_customer_dto.dart';
import '../../../data/remote/dto/auth/register_customer_out_dto.dart';
import '../../../data/remote/repositories/auth/auth_repository.dart';
import '../../../di/locator.dart';
import '../../../domain/enums/user_type.dart';
import '../../../utils/functions.dart';
import '../../../widgets/snackbars.dart';
import '../../../routes/app_pages.dart'; // Ensure Routes is imported
import '../views/login/widgets/choose_bottom_sheet.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();
  final _authRepository = getIt.get<AuthRepository>();

  /*
   * Customer Form Fields.
   * */
  final GlobalKey<FormState> customerFormKey = GlobalKey<FormState>();
  final customerFullNameController = TextEditingController();
  final customerPhoneNumController = TextEditingController();
  final customerEmailController = TextEditingController();
  final customerPasswordController = TextEditingController();

  /*
   * Company Form Fields
   * */
  final GlobalKey<FormState> companyFormKey = GlobalKey<FormState>();
  final companyNameController = TextEditingController();
  final companyBusinessNumberController = TextEditingController();
  final companyBusinessEmailController = TextEditingController();
  final companyAddressController = TextEditingController();
  final companyCountryController = TextEditingController();
  final companyPasswordController = TextEditingController();

  /*
   * Login Form Fields
   * */
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  /*
   * Rx
   * */

  final RxString _rxCountry = RxString('');

  String get country => _rxCountry.value;

  final Rxn<UserEntity> _rxnCurrentUser = Rxn<UserEntity>();

  UserEntity? get currentUser => _rxnCurrentUser.value;

  // Corrected initialization to use Status.loading() and explicitly typed
  final Rx<Status<RegisterCustomerOutDto>> _rxRegisterCustomerState =
      Rx(Status<RegisterCustomerOutDto>.loading());

  Status<RegisterCustomerOutDto> get registerCustomerState =>
      _rxRegisterCustomerState.value;

  // Corrected initialization to use Status.loading() and explicitly typed
  final Rx<Status<RegisterCompanyOutDto>> _rxRegisterCompanyState =
      Rx(Status<RegisterCompanyOutDto>.loading());

  Status<RegisterCompanyOutDto> get registerCompanyState =>
      _rxRegisterCompanyState.value;

  // Corrected initialization to use Status.loading() and explicitly typed
  final Rx<Status<LoginOutDto>> _rxLoginState = Rx(Status<LoginOutDto>.loading());

  Status<LoginOutDto> get loginState => _rxLoginState.value;

  final RxBool _rxIsObscure = RxBool(true);

  bool get isObscure => _rxIsObscure.value;

  final Rx<RegisterType> _rxRegisterType = Rx(RegisterType.NOTSELECTED);

  RegisterType get registerType => _rxRegisterType.value;

  @override
  void onInit() {
    super.onInit();
    _getCurrentUser();
    if (!kIsWeb) {
      try {
        final CountryDetails details = CountryCodes.detailsForLocale();
        _rxCountry.value = details.dialCode ?? '';
      } catch (e) {
        debugPrint("Could not get country details for locale: $e");
        _rxCountry.value = ''; // Fallback value
      }
    }
  }

  @override
  void onClose() {
    super.onClose();
    loginEmailController.dispose();
    loginPasswordController.dispose();
    customerFullNameController.dispose();
    customerPhoneNumController.dispose();
    customerEmailController.dispose();
    customerPasswordController.dispose();
    companyNameController.dispose();
    companyBusinessEmailController.dispose();
    companyBusinessNumberController.dispose();
    companyCountryController.dispose();
    companyAddressController.dispose();
    companyPasswordController.dispose();
  }

  void _getCurrentUser() async {
    final result = await _authRepository.readStorage(key: 'user');
    // Using isSuccess getter and direct data access
    if (result.isSuccess) {
      if (result.data != null) {
        _rxnCurrentUser.value = UserEntity.fromMap(result.data);
      }
    }
  }

  void onCountryChanged(Country country) {
    _rxCountry.value = "+${country.dialCode}";
  }

  Future<void> onLoginSubmit() async {
    if (loginFormKey.currentState!.validate()) {
      await _login();
    }
  }

  Future<void> onRegisterSubmit() async {
    if (registerType == RegisterType.CUSTOMER &&
        customerFormKey.currentState!.validate()) {
      await _registerCustomer();
    } else if (registerType == RegisterType.COMPANY &&
        companyFormKey.currentState!.validate()) {
      await _registerCompany();
    }
  }

  void logout() async {
    final result = await _authRepository.removeStorage(key: 'user');
    // Using isSuccess getter
    if (result.isSuccess) {
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  Future<void> _login() async {
    _rxLoginState.value = await _authRepository.login(
      dto: LoginInDto(
        emailOrPhone: loginEmailController.text,
        password: loginPasswordController.text,
      ),
    );
    // Using isSuccess and isError getters
    if (loginState.isSuccess) {
      final data = loginState.data;
      if (data != null) {
        _saveUserInStorage(
          id: data.id,
          email: data.email,
          name: data.name,
          token: data.token!.access,
          role: data.role,
          status: data.status,
        );
        _getCurrentUser();
        Get.offAllNamed(Routes.ROOT);
        _clearTextControllers();
      }
    } else if (loginState.isError) {
      showSnackBarOnFailure(loginState.message);
    }
  }

  Future<void> _registerCustomer() async {
    _rxRegisterCustomerState.value = await _authRepository.registerCustomer(
      dto: RegisterCustomerDto(
        name: customerFullNameController.text,
        email: customerEmailController.text,
        password: customerPasswordController.text,
        phone: "$country${customerPhoneNumController.text}",
      ),
    );
    // Using isSuccess and isError getters
    if (registerCustomerState.isSuccess) {
      final data = registerCustomerState.data;
      if (data != null) {
        _saveUserInStorage(
            id: data.customer!.id,
            token: data.token!.access,
            name: data.customer!.name,
            email: data.customer!.email,
            phone: data.customer!.phone,
            role: "CUSTOMER",
            status: "APPROVED");
        _getCurrentUser();
        Get.offAllNamed(Routes.ROOT);
        _clearTextControllers();
      }
    } else if (registerCustomerState.isError) {
      showSnackBarOnFailure(registerCustomerState.message);
    }
  }

  Future<void> _registerCompany() async {
    _rxRegisterCompanyState.value = await _authRepository.registerCompany(
      dto: RegisterCompanyDto(
        name: companyNameController.text,
        country: companyCountryController.text,
        address: companyAddressController.text,
        phone: "$country${companyBusinessNumberController.text}",
        email: companyBusinessEmailController.text,
        password: companyPasswordController.text,
      ),
    );
    // Using isSuccess and isError getters
    if (registerCompanyState.isSuccess) {
      Get.offAllNamed(Routes.WAITTING);
      _clearTextControllers();
    } else if (registerCompanyState.isError) {
      showSnackBarOnFailure(registerCompanyState.message);
    }
  }

  void _saveUserInStorage({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? token,
    String? role,
    String? status,
  }) async {
    await _authRepository.writeStorage(
      key: 'user',
      entity: UserEntity(
        id: id,
        name: name,
        email: email,
        phoneNumber: phone,
        token: token,
        role: role,
        status: status,
      ),
    );
  }

  void toggleObscurePassword() {
    _rxIsObscure.value = !isObscure;
  }

  void _clearTextControllers() {
    loginEmailController.clear();
    loginPasswordController.clear();
    customerFullNameController.clear();
    customerPhoneNumController.clear();
    customerEmailController.clear();
    customerPasswordController.clear();
    companyNameController.clear();
    companyBusinessEmailController.clear();
    companyBusinessNumberController.clear();
    companyCountryController.clear();
    companyAddressController.clear();
    companyPasswordController.clear();
  }

  void onSignUp() {
    popupBottomSheet(
      bottomSheetBody: const ChooseBottomSheetBody(),
      isDismissible: true,
      enableDrag: true,
    );
  }

  void onSelectRegisterType(RegisterType type) {
    if (type != RegisterType.NOTSELECTED) {
      _rxRegisterType.value = type;
      Get.offAllNamed(Routes.REGISTER);
    }
  }

  void showSnackBarOnFailure(String? err) {
    Get.closeAllSnackbars();
    SnackBars.failure("Oops!", err.toString());
  }
}
