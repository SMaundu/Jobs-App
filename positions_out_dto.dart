import 'position_out_dto.dart';

class PositionsOutDto {
  PositionsOutDto({this.positions});

  PositionsOutDto.fromJson(dynamic json) {
    if (json['data'] != null) {
      positions = positionsFromJson(json['data']);
    }
  }

  List<PositionOutDto>? positions;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (positions != null) {
      map['data'] = positions?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
