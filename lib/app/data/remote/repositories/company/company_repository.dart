import 'package:dio/dio.dart';

import '../../base/status.dart';
import '../../dto/company/Company_out_dto.dart'; // Corrected capitalization for consistency if needed, but keeping as is per user input
import '../../exceptions/dio_exceptions.dart';
import '../../services/company/i_company_service.dart';
import 'i_company_repository.dart';

class CompanyRepository implements ICompanyRepository<CompanyOutDto> {
  final ICompanyService service;

  CompanyRepository({required this.service});

  @override
  Future<Status<CompanyOutDto>> get({required String uuid}) async {
    try {
      final response = await service.get(uuid: uuid);
      if (response.statusCode == 200) {
        final CompanyOutDto company = CompanyOutDto.fromJson(response.data); // Renamed 'job' to 'company' for clarity
        return Status.success(company); // Changed from Status.success(data: job) to Status.success(company)
      }
      return Status.error(message: "Something went wrong!"); // Changed from Status.failure(reason: ...) to Status.error(message: ...)
    } on DioError catch (e) {
      final errMsg = DioExceptions.fromDioError(e).toString();
      return Status.error(message: errMsg); // Changed from Status.failure(reason: ...) to Status.error(message: ...)
    }
  }
}
