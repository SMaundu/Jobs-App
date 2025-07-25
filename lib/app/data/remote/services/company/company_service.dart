import 'package:dio/dio.dart';

import '../../api/dio_client.dart';

class CompanyService {
  final DioClient _dioClient;

  CompanyService({required DioClient dioClient}) : _dioClient = dioClient;

  Future<Response> getCompanies() async {
    try {
      return await _dioClient.get("/companies");
    } catch (e) {
      rethrow;
    }
  }
}
