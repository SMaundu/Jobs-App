import 'package:dio/dio.dart';

import 'package:jobs_flutter_app/app/data/remote/base/status.dart' as base_status;
// Corrected import path and casing for the DTO file
import 'package:jobs_flutter_app/app/data/remote/dto/position/position_out_dto.dart';
import '../../services/position/i_choice_service.dart';

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
      final List<PositionOutDto> positions = positionsFromJson(response.data);

      return base_status.Status.success(data: positions);
    } on DioException catch (e) {
      return base_status.Status.failure(reason: e.message ?? "An error occurred");
    } catch (e) {
      return base_status.Status.failure(reason: e.toString());
    }
  }
}