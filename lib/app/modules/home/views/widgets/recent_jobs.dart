import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';

import '../../../../data/remote/api/api_routes.dart';
import '../../../../data/remote/dto/job/job_out_dto.dart';
import '../../../../routes/app_pages.dart';
import '../../../../widgets/custom_job_card.dart';
import '../../../../widgets/custom_lottie.dart';
import '../../../../widgets/section_header.dart';
import '../../../../widgets/shimmer/recent_jobs_shimmer.dart';
import '../../../saved/controllers/saved_controller.dart';
import '../../controllers/home_controller.dart';
import '../../../../data/remote/base/status.dart'; // Ensure Status class is imported

class RecentJobs extends GetView<HomeController> {
  const RecentJobs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SectionHeader(title: "Recent Jobs"),
        SizedBox(height: 16.h),
        Obx(
          () {
            final recentJobsStatus = controller.recentJobs; // Get the current status

            if (recentJobsStatus.isLoading) {
              return const RecentJobsShimmer(); // Show shimmer for loading
            } else if (recentJobsStatus.isSuccess) {
              final jobs = recentJobsStatus.data; // Access data directly

              if (jobs == null || jobs.isEmpty) {
                return CustomLottie(
                  title: "No jobs found with this position",
                  asset: "assets/empty.json",
                  assetHeight: 200.h,
                  padding: EdgeInsets.zero,
                );
              } else {
                return ListView.builder(
                  itemCount: jobs.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final job = jobs[index]; // Get the current job for easier access
                    return CustomJobCard(
                      // Safely access company image. Use a placeholder if company or image is null.
                      avatar: "${ApiRoutes.BASE_URL}${job.company?.image ?? 'placeholder.png'}",
                      // Safely access company name. Provide empty string if company or name is null.
                      companyName: job.company?.name ?? '',
                      // Safely access createdAt and format it. Provide empty string if null.
                      publishTime: job.createdAt?.toIso8601String() ?? '', // Convert DateTime to String
                      // Safely access jobPosition. Provide empty string if null.
                      jobPosition: job.position ?? '',
                      // Safely access workplace. Provide empty string if null.
                      workplace: job.workplace ?? '',
                      // Safely access location. Provide empty string if null.
                      location: job.location ?? '',
                      // Safely access employmentType. Provide empty string if null.
                      employmentType: job.employmentType ?? '',
                      isFeatured: false,
                      actionIcon: HeroIcons.bookmark,
                      // Safely check if job is saved. Provide empty string if id is null.
                      isSaved: SavedController.to.isJobSaved(job.id ?? ''),
                      // Safely access description. Provide empty string if null.
                      description: job.description ?? '',
                      onTap: () => Get.toNamed(
                        Routes.JOB_DETAILS,
                        // Safely access job ID. Provide empty string if id is null.
                        arguments: job.id ?? '',
                      ),
                      onAvatarTap: () => Get.toNamed(
                        Routes.COMPANY_PROFILE,
                        // Safely access company ID. Provide empty string if company or id is null.
                        arguments: job.company?.id ?? '',
                      ),
                      onActionTap: (isSaved) =>
                          controller.onSaveButtonTapped(isSaved, job.id ?? ''), // Provide empty string if id is null
                    );
                  },
                );
              }
            } else if (recentJobsStatus.isError) {
              // Access message directly
              return CustomLottie(
                asset: "assets/space.json",
                repeat: true,
                title: recentJobsStatus.message ?? "An unexpected error occurred.", // Use status.message
                onTryAgain: controller.loadHomeData, // Assuming loadHomeData can retry fetching all home data
              );
            }
            // Fallback for any unhandled state (e.g., initial idle state if not loading, success, or error)
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
