import '../base/idto.dart';

List<PositionOutDto> positionsFromJson(List<dynamic> list) =>
    List<PositionOutDto>.from(list.map((x) => PositionOutDto.fromJson(x)));

class PositionOutDto implements IDto {
  PositionOutDto({this.id, this.name});

  PositionOutDto.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }

  String? id;
  String? name;

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }
}
