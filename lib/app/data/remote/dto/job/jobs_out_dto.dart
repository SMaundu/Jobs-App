import 'job_out_dto.dart';

class JobsOutDto {
  JobsOutDto({this.jobs});

  JobsOutDto.fromJson(dynamic json) {
    if (json['data'] != null) {
      jobs = jobsFromJson(json['data']);
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
