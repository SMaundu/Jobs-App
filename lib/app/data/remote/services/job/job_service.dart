import 'package:dio/dio.dart';

import '../../api/dio_client.dart';

/// A service class for handling job-related API calls.
class JobService {
  final DioClient _dioClient;

  JobService({required DioClient dioClient}) : _dioClient = dioClient;

  Future<Response> get({required String uuid}) async {
    return await _dioClient.get('/jobs/$uuid'); // TODO: Adjust endpoint if needed
  }

  Future<Response> getAll({Map<String, dynamic>? queryParameters}) async {
    return await _dioClient.get('/jobs', // TODO: Adjust endpoint if needed
        queryParameters: queryParameters);
  }
}