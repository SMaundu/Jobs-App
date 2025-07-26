class PositionOutDto {
  PositionOutDto({
    this.id,
    this.name,
  });

  PositionOutDto.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }

  String? id;
  String? name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }
}

List<PositionOutDto> positionsFromJson(List<dynamic> json) =>
    List<PositionOutDto>.from(json.map((x) => PositionOutDto.fromJson(x)));

    