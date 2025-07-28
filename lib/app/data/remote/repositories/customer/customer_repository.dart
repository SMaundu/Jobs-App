import 'package:dio/dio.dart';

import 'package:jobs_flutter_app/app/data/remote/base/status.dart';
import 'package:jobs_flutter_app/app/data/remote/dto/customer/customer_out_dto.dart'; // Keep this if used elsewhere
import 'package:jobs_flutter_app/app/data/remote/dto/customer/customer_profile_out_dto.dart'; // Import CustomerProfileOutDto
import 'package:jobs_flutter_app/app/data/remote/dto/job/jobs_out_dto.dart';
import 'package:jobs_flutter_app/app/data/remote/services/customer/customer_service.dart';

/// A repository for handling customer-related API requests.
class CustomerRepository {
  final CustomerService _service;

  CustomerRepository({required CustomerService service}) : _service = service;

  /// Fetches the current customer's profile.
  // Changed return type to CustomerProfileOutDto
  Future<Status<CustomerProfileOutDto>> getCustomerProfile({required String customerUuid}) async {
    try {
      final response = await _service.getProfile(customerUuid: customerUuid);
      // Changed DTO parsing to CustomerProfileOutDto
      final dto = CustomerProfileOutDto.fromJson(response.data);

      return Status.success(dto);
    } on DioException catch (e) {
      return Status.error(message: e.message ?? "An error occurred during profile fetch.");
    } catch (e) {
      return Status.error(message: "An unexpected error occurred: ${e.toString()}");
    }
  }

  Future<Status<JobsOutDto>> getAllSavedJobs({required String customerId}) async {
    try {
      final response = await _service.getSavedJobs(customerId);
      final dto = JobsOutDto.fromJson(response.data);
      return Status.success(dto);
    } on DioException catch (e) {
      return Status.error(message: e.message ?? "Failed to fetch saved jobs.");
    } catch (e) {
      return Status.error(message: "An unexpected error occurred: ${e.toString()}");
    }
  }

  Future<Status<dynamic>> toggleSave(String customerId, {required String jobUuid}) async {
    try {
      final response = await _service.toggleJobSave(customerId, jobUuid: jobUuid);
      return Status.success(response.data);
    } on DioException catch (e) {
      return Status.error(message: e.message ?? "Failed to toggle job save status.");
    } catch (e) {
      return Status.error(message: "An unexpected error occurred: ${e.toString()}");
    }
  }

  // Changed return type to CustomerProfileOutDto
  Future<Status<CustomerProfileOutDto>> getProfile({required String customerUuid}) async {
    return await getCustomerProfile(customerUuid: customerUuid);
  }
}
