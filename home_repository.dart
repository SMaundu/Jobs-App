import 'package:dio/dio.dart';

import '../../dto/job/jobs_out_dto.dart';
import '../../dto/position/positions_out_dto.dart';
import '../customer/customer_repository.dart';
import '../job/job_repository.dart';
import '../position/position_repository.dart';

class HomeRepository {
  final JobRepository _jobRepository;
  final PositionRepository _positionRepository;
  final CustomerRepository _customerRepository;

  HomeRepository({
    required JobRepository jobRepository,
    required PositionRepository positionRepository,
    required CustomerRepository customerRepository,
  }) : _jobRepository = jobRepository,
       _positionRepository = positionRepository,
       _customerRepository = customerRepository;

  Future<Response<JobsOutDto>> getFeaturedJobs() async {
    return _jobRepository.getFeaturedJobs();
  }

  Future<Response<JobsOutDto>> getRecentJobs() async {
    return _jobRepository.getRecentJobs();
  }

  Future<Response<PositionsOutDto>> getPositions() async {
    return _positionRepository.getPositions();
  }

  Future<Response> getCustomerProfile() async {
    return _customerRepository.getCustomerProfile();
  }
}
