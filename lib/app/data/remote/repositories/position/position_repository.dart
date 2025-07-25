import 'package:dio/dio.dart';

import '../../base/status.dart';
import '../../dto/position/position_out_dto.dart';
import '../../exceptions/dio_exceptions.dart';
import '../../services/position/i_choice_service.dart';
import 'i_choice_repository.dart';

class PositionRepository extends IChoiceRepository<PositionOutDto> {
  final IChoiceService service;

  PositionRepository({required this.service});

  @override
  Future<Status<List<PositionOutDto>>> getAll({int? limit, int? offset}) async {
    try {
      final response = await service.getAll(limit: limit, offset: offset);
      final positions = (response.data as List)
          .map((e) => PositionOutDto.fromJson(e))
          .toList();
      if (response.statusCode == 200) return Status.success(data: positions);
      return const Status.failure(reason: "Some thing wrong happen!");
    } on DioError catch (e) {
      final errMsg = DioExceptions.fromDioError(e).toString();
      return Status.failure(reason: errMsg);
    }
  }
}
