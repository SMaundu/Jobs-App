import 'package:dio/dio.dart';

import 'package:jobs_flutter_app/app/data/remote/base/status.dart'; // Adjust the import path as necessary
// Ensure that the Status class is defined in the imported file or define it below if missing.
import '../../dto/job/job_out_dto.dart';
import '../../dto/job/jobs_out_dto.dart';
import '../../services/job/job_service.dart';

/// A repository for handling job-related API requests.
/// It uses a [JobService] to communicate with the backend.
class JobRepository {
  final JobService _service;

  JobRepository({required JobService service}) : _service = service;

  /// Fetches a single job by its UUID.
  Future<Status<JobOutDto>> get({required String uuid}) async {
    try {
      final response = await _service.get(uuid: uuid);
      // Assuming the single job object is nested under a 'data' key.
      final job = JobOutDto.fromJson(response.data['data']);
      return Status.success(data: job);
    } on DioException catch (e) {
      return Status.failure(reason: e.message ?? "An error occurred");
    } catch (e) {
      return Status.failure(reason: e.toString());
    }
  }

  /// Fetches a list of jobs, with optional filters.
  ///
  /// Can be filtered by [companyId] or [position].
  Future<Status<List<JobOutDto>>> getAll({
    String? companyId,
    String? position,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (companyId != null) {
        // The key 'company' should match what your API expects.
        queryParameters['company'] = companyId;
      }
      if (position != null) {
        queryParameters['position'] = position;
      }

      final response = await _service.getAll(queryParameters: queryParameters);
      // JobsOutDto parses the list from the response data.
      final jobsOutDto = JobsOutDto.fromJson(response.data);
      return Status.success(data: jobsOutDto.jobs ?? []);
    } on DioException catch (e) {
      return Status.failure(reason: e.message ?? "An error occurred");
    } catch (e) {
      return Status.failure(reason: e.toString());
    }
  }

  /// Fetches a list of jobs from the API, with generic filtering.
  ///
  /// This method returns a [Status] object, wrapping the [JobsOutDto] on success
  /// or a failure reason. It uses a generic [queryParameters] map for flexibility.
  Future<Status<JobsOutDto>> getJobs(
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _service.getAll(queryParameters: queryParameters);
      final dto = JobsOutDto.fromJson(response.data);
      return Status.success(data: dto);
    } on DioException catch (e) {
      return Status.failure(reason: e.message ?? "An error occurred");
    } catch (e) {
      return Status.failure(reason: e.toString());
    }
  }
}