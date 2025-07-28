import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/shimmer/job_details_shimmer.dart';
import '../../controllers/job_details_controller.dart';
import 'about_the_employer.dart';
import 'description.dart';
import 'details_sliver_app_bar.dart';
import 'similar_jobs.dart';

class Body extends GetView<JobDetailsController> {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final jobStatus = controller.job; // Get the current status

        if (jobStatus.isLoading) {
          return const JobDetailsShimmer(); // Show shimmer for loading
        } else if (jobStatus.isError) {
          // Show shimmer or an error message for failure
          return const JobDetailsShimmer(); // Or a CustomLottie with retry option
        } else if (jobStatus.isSuccess) {
          final job = jobStatus.data; // Access data directly

          if (job == null) {
            // Handle case where job data is null even if status is success
            return const Center(child: Text("Job details not available."));
          }

          return CustomScrollView(
            slivers: [
              DetailsSliverAppBar(job: job), // job is now non-nullable here
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Description(job: job),
                    AboutTheEmployer(job: job),
                    const SimilarJobs(),
                  ],
                ),
              )
            ],
          );
        }
        // Fallback for any unhandled status (e.g., initial idle state if not loading, success, or error)
        return const SizedBox.shrink();
      },
    );
  }
}
