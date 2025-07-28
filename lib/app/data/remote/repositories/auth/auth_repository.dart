import 'package:dio/dio.dart';

import '../../../local/base/i_entity.dart';
import '../../../local/services/storage_service.dart';
import 'i_auth_repository.dart';
import '../../base/idto.dart';
import '../../base/status.dart'; // Ensure this Status class matches the one I provided earlier
import '../../dto/auth/login_out_dto.dart';
import '../../dto/auth/register_company_out_dto.dart';
import '../../dto/auth/register_customer_out_dto.dart';
import '../../exceptions/dio_exceptions.dart';
import '../../services/auth/auth_service.dart';

class AuthRepository implements IAuthRepository<Status<dynamic>> {
  final AuthService authService;
  final StorageService storageService;

  AuthRepository({
    required this.authService,
    required this.storageService,
  });

  @override
  Future<Status<LoginOutDto>> login({required IDto dto}) async {
    try {
      final response = await authService.login(dto: dto);
      return Status.success(LoginOutDto.fromJson(response.data)); // Changed from Status.success(data: ...)
    } on DioError catch (e) {
      final errMsg = DioExceptions.fromDioError(e).toString();
      return Status.error(message: errMsg); // Changed from Status.failure(reason: ...)
    }
  }

  @override
  Future<Status<RegisterCompanyOutDto>> registerCompany(
      {required IDto dto}) async {
    try {
      final response = await authService.registerCompany(dto: dto);
      return Status.success(
          RegisterCompanyOutDto.fromJson(response.data)); // Changed from Status.success(data: ...)
    } on DioError catch (e) {
      final errMsg = DioExceptions.fromDioError(e).toString();
      return Status.error(message: errMsg); // Changed from Status.failure(reason: ...)
    }
  }

  @override
  Future<Status<RegisterCustomerOutDto>> registerCustomer({
    required IDto dto,
  }) async {
    try {
      final response = await authService.registerCustomer(dto: dto);
      return Status.success(
          RegisterCustomerOutDto.fromJson(response.data)); // Changed from Status.success(data: ...)
    } on DioError catch (e) {
      final errMsg = DioExceptions.fromDioError(e).toString();
      return Status.error(message: errMsg); // Changed from Status.failure(reason: ...)
    }
  }

  /*
   * Local Storage
   * */
  @override
  Future<Status<dynamic>> readStorage({required String key}) async {
    try {
      final result = await storageService.read(key: key);
      if (result != null) return Status.success(result); // Changed from Status.success(data: ...)
      return Status.error(message: "Not Found!"); // Changed from Status.failure(reason: ...)
    } catch (e) {
      return Status.error(message: e.toString()); // Changed from Status.failure(reason: ...)
    }
  }

  @override
  Future<Status> writeStorage({
    required String key,
    required IEntity entity,
  }) async {
    try {
      await storageService.write(key: key, entity: entity);
      return Status.success("User has been saved successfully."); // Changed from Status.success(data: ...)
    } catch (e) {
      return Status.error(message: e.toString()); // Changed from Status.failure(reason: ...)
    }
  }

  @override
  Future<Status> removeStorage({required String key}) async {
    try {
      await storageService.remove(key: key);
      return Status.success("User has been removed successfully."); // Changed from Status.success(data: ...)
    } catch (e) {
      return Status.error(message: e.toString()); // Changed from Status.failure(reason: ...)
    }
  }
}
