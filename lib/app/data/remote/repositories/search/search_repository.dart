import 'package:dio/dio.dart';

import '../../base/status.dart'; // Ensure this Status class matches the one provided in status_class_definition
import '../../dto/search/search_out_dto.dart';
import '../../exceptions/dio_exceptions.dart';
import '../../services/search/i_search_service.dart';
import 'i_search_repository.dart';

class SearchRepository implements ISearchRepository {
  final ISearchService service;

  SearchRepository({required this.service});

  @override
  Future<Status<List<SearchOutDto>>> getAll(
      {int? limit, int? offset, String? q}) async {
    try {
      final response = await service.getAll(limit: limit, offset: offset, q: q);
      // Explicitly cast response.data to List<dynamic> and then map to List<SearchOutDto>
      final List<SearchOutDto> results = (response.data as List<dynamic>)
          .map((e) => SearchOutDto.fromJson(e as Map<String, dynamic>)) // Explicitly cast 'e' to Map<String, dynamic>
          .toList();

      // Ensure Status.success receives a List<SearchOutDto>
      return Status.success(results);
    } on DioException catch (e) {
      final errMsg = DioExceptions.fromDioError(e).toString();
      // Corrected: Changed Status.failure to Status.error and passed message
      return Status.error(message: errMsg);
    } catch (e) {
      // Catch any other unexpected errors
      // Corrected: Changed Status.failure to Status.error and passed message
      return Status.error(message: e.toString());
    }
  }
}
