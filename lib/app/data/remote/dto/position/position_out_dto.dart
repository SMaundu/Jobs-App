/// Data Transfer Object for a single job position.
class PositionOutDto {
  final String? id;
  final String? name; // Changed from 'title' to 'name' as per your input

  PositionOutDto({
    this.id,
    this.name, // Changed from 'title' to 'name'
  });

  factory PositionOutDto.fromJson(Map<String, dynamic> json) {
    return PositionOutDto(
      id: json['id'],
      name: json['name'], // Changed from 'title' to 'name'
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name, // Changed from 'title' to 'name'
      };
}

/// Helper function to parse a list of JSON objects into a List of PositionOutDto.
List<PositionOutDto> positionsFromJson(List<dynamic> json) =>
    List<PositionOutDto>.from(json.map((x) => PositionOutDto.fromJson(x as Map<String, dynamic>)));
