import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../data/remote/api/api_routes.dart';
import '../../../../routes/app_pages.dart';
import '../../../../widgets/section_header.dart';
import '../../controllers/job_details_controller.dart';
import 'slimilar_job_card.dart'; // Note: The file name is 'slimilar_job_card.dart', might be a typo for 'similar_job_card.dart'

class SimilarJobs extends GetView<JobDetailsController> {
  const SimilarJobs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        // Removed .value because controller.similarJobs is expected to be the Status object itself
        final status = controller.similarJobs; 

        if (status.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (status.isError) {
          return Center(
            child: Text(status.message ?? "An unknown error occurred while loading similar jobs."),
          );
        } else if (status.isSuccess) {
          final jobs = status.data; // Access the data from the status

          if (jobs == null || jobs.isEmpty) {
            return Container(); // Or a CustomLottie indicating no similar jobs
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                const SectionHeader(title: "Similar Jobs"),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.only(right: 16.w),
                    child: Row(
                      children: List.generate(
                        jobs.length,
                        (index) {
                          final job = jobs[index]; // Get the current job for easier access

                          return SimilarJobCard(
                            workplace: job.workplace ?? '', // Null-safe access
                            publishTime: job.createdAt?.toIso8601String() ?? '', // Null-safe access and formatting
                            location: job.location ?? '', // Null-safe access
                            jobPosition: job.position ?? '', // Null-safe access
                            companyName: job.company?.name ?? '', // Null-safe access
                            employmentType: job.employmentType ?? '', // Null-safe access
                            avatar: "${ApiRoutes.BASE_URL}${job.company?.image ?? 'placeholder.png'}", // Null-safe access with placeholder
                            onTap: () => Get.toNamed(
                              Routes.JOB_DETAILS, // Changed to JOB_DETAILS as it's a similar job, not company profile
                              arguments: job.id ?? '', // Null-safe access
                              preventDuplicates: false,
                            ),
                            onAvatarTap: () => Get.toNamed(
                              Routes.COMPANY_PROFILE,
                              arguments: job.company?.id ?? '', // Null-safe access
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        }
        return Container(); // Fallback for any unhandled status
      },
    );
  }
}
