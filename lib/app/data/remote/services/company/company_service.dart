import 'package:dio/dio.dart';

import '../../api/api_routes.dart';
import '../../api/dio_client.dart';
import 'i_company_service.dart';

class CompanyService implements ICompanyService {
  final DioClient _dioClient;

  CompanyService({required DioClient dioClient}) : _dioClient = dioClient;

  @override
  Future<Response> get({required String uuid}) async {
    try {
      return await _dioClient.get("${ApiRoutes.COMPANIES}$uuid");
    } catch (e) {
      rethrow;
    }
  }
}
