/// Data Transfer Object for a single job.
class JobOutDto {
  final String? id;
  final String? title;
  final String? position;
  // TODO: Add other fields from your API response (e.g., description, salary, etc.)

  JobOutDto({
    this.id,
    this.title,
    this.position,
  });

  factory JobOutDto.fromJson(Map<String, dynamic> json) {
    return JobOutDto(
      id: json['id'],
      title: json['title'],
      position: json['position'],
      // ... parse other fields
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'position': position,
      };
}