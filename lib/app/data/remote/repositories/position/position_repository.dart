import 'package:dio/dio.dart';

import 'package:jobs_flutter_app/app/data/remote/base/status.dart' as base_status;
// Corrected import path and casing for the DTO file
import 'package:jobs_flutter_app/app/data/remote/dto/position/position_out_dto.dart';
import 'package:jobs_flutter_app/app/data/remote/services/position/i_choice_service.dart';
import 'package:jobs_flutter_app/app/data/remote/exceptions/dio_exceptions.dart'; // Import DioExceptions

class PositionRepository {
  final IChoiceService service;

  PositionRepository({required this.service});

  // Corrected the generic type to List<PositionOutDto>
  // and ensured the casing matches the DTO class definition.
  Future<base_status.Status<List<PositionOutDto>>> getPositions(
      {int? limit, int? offset}) async {
    try {
      final response = await service.getAll(limit: limit, offset: offset);

      // Assuming response.data is a List<dynamic> which can be parsed
      // by the positionsFromJson helper function.
      // You might need to define positionsFromJson or adjust this parsing
      // if response.data is directly the list or needs a different parsing method.
      // For example, if response.data is already List<Map<String, dynamic>>:
      final List<PositionOutDto> positions = (response.data as List)
          .map((e) => PositionOutDto.fromJson(e as Map<String, dynamic>))
          .toList();

      return base_status.Status.success(positions); // Changed from Status.success(data: positions)
    } on DioException catch (e) { // Changed DioError to DioException
      final errMsg = DioExceptions.fromDioError(e).toString();
      return base_status.Status.error(message: errMsg); // Changed from Status.failure(reason: errMsg)
    } catch (e) {
      return base_status.Status.error(message: e.toString()); // Changed from Status.failure(reason: e.toString())
    }
  }
}
