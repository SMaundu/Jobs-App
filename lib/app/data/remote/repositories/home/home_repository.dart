import '../../base/status.dart';
import '../../dto/job/jobs_out_dto.dart';
import '../../dto/position/position_out_dto.dart';
import '../../dto/customer/customer_out_dto.dart';
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

  Future<Status<JobsOutDto>> getFeaturedJobs() async {
    // JobRepository's getJobs method now returns a Status object.
    return _jobRepository.getJobs(queryParameters: {'featured': 'true'});
  }

  Future<Status<JobsOutDto>> getRecentJobs() async {
    // The backend should sort by creation date to get the most recent jobs.
    return _jobRepository.getJobs(queryParameters: {'sort': 'createdAt,desc'});
  }

  Future<Status<List<PositionOutDto>>> getPositions() async {
    return _positionRepository.getPositions();
  }

  Future<Status<CustomerOutDto>> getCustomerProfile() async {
    // This assumes CustomerRepository has a getCustomerProfile method
    // that is also refactored to return a Status<CustomerOutDto>.
    return _customerRepository.getCustomerProfile();
  }
}
