import 'package:dio/dio.dart';
import 'package:jobs_flutter_app/app/data/remote/api/dio_client.dart'; // Assuming DioClient is used

/// Service class for handling customer-related API calls.
class CustomerService {
  final DioClient _dioClient;

  CustomerService({required DioClient dioClient}) : _dioClient = dioClient;

  /// Fetches the current customer's profile.
  /// Requires the [customerUuid] to identify the customer.
  Future<Response> getProfile({required String customerUuid}) async {
    // Example API call. Adjust the endpoint as per your backend.
    return await _dioClient.get('/customers/$customerUuid/profile');
  }

  /// Fetches all saved jobs for a given customer.
  /// Requires the [customerId] to identify the customer.
  Future<Response> getSavedJobs(String customerId) async {
    // Example API call. Adjust the endpoint as per your backend.
    return await _dioClient.get('/customers/$customerId/saved-jobs');
  }

  /// Toggles the save status of a job for a given customer.
  /// Requires [customerId] and [jobUuid].
  Future<Response> toggleJobSave(String customerId, {required String jobUuid}) async {
    // Example API call. Adjust the endpoint and method (POST/PUT/DELETE) as per your backend.
    // This assumes a POST request to toggle the status.
    return await _dioClient.post('/customers/$customerId/jobs/$jobUuid/toggle-save');
  }

  // Add other customer-related service methods here as needed.
}
