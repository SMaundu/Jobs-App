import 'job_out_dto.dart';

/// Data Transfer Object for a list of jobs, typically from a paginated response.
class JobsOutDto {
  JobsOutDto({this.jobs});

  JobsOutDto.fromJson(dynamic json) {
    if (json['data'] != null && json['data'] is List) {
      jobs = List<JobOutDto>.from(
        (json['data'] as List).map((x) => JobOutDto.fromJson(x)),
      );
    }
  }

  List<JobOutDto>? jobs;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (jobs != null) {
      map['data'] = jobs?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}