import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../data/remote/api/api_routes.dart';
import '../../../../routes/app_pages.dart';
import '../../../../widgets/custom_job_card.dart';
import '../../../../widgets/shimmer/featured_job_shimmer.dart';
import '../../../saved/controllers/saved_controller.dart';
import '../../controllers/home_controller.dart';
import '../../../../widgets/section_header.dart';
import '../../../../data/remote/base/status.dart'; // Ensure Status class is imported

class FeaturedJobs extends GetView<HomeController> {
  const FeaturedJobs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final featuredJobsStatus = controller.featuredJobs; // Get the current status

        if (featuredJobsStatus.isLoading) {
          return const FeaturedJobShimmer(); // Show shimmer for loading
        } else if (featuredJobsStatus.isSuccess) {
          final jobs = featuredJobsStatus.data; // Access data directly

          if (jobs == null || jobs.isEmpty) {
            // If no jobs are returned or the list is empty, show an empty container
            return const SizedBox.shrink();
          }

          return Column(
            children: [
              const SectionHeader(title: "Featured Jobs"),
              SizedBox(height: 16.h),
              CarouselSlider.builder(
                itemCount: jobs.length,
                itemBuilder: (context, index, realIndex) {
                  final job = jobs[index]; // Get the current job for easier access
                  return CustomJobCard(
                    isFeatured: true,
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
                    // Safely access employmentType. Provide empty string if null.
                    employmentType: job.employmentType ?? '',
                    // Safely access location. Provide empty string if null.
                    location: job.location ?? '',
                    actionIcon: HeroIcons.bookmark,
                    // Safely check if job is saved. Provide empty string if id is null.
                    isSaved: SavedController.to.isJobSaved(job.id ?? ''),
                    onAvatarTap: () => Get.toNamed(
                      Routes.COMPANY_PROFILE,
                      // Safely access company ID. Provide empty string if company or id is null.
                      arguments: job.company?.id ?? '',
                    ),
                    onTap: () => Get.toNamed(
                      Routes.JOB_DETAILS,
                      // Safely access job ID. Provide empty string if id is null.
                      arguments: job.id ?? '',
                    ),
                    onActionTap: (isSaved) =>
                        controller.onSaveButtonTapped(isSaved, job.id ?? ''), // Provide empty string if id is null
                  );
                },
                options: CarouselOptions(
                  height: 1.sh / 4.4,
                  viewportFraction: 1,
                  initialPage: 0,
                  onPageChanged: controller.updateIndicatorValue,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: false,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: false,
                  scrollDirection: Axis.horizontal,
                ),
              ),
              // SizedBox(height: 8.h), // This line was commented out, keeping it that way.
              Obx(
                () => AnimatedSmoothIndicator(
                  count: jobs.length, // Use the actual jobs length
                  activeIndex: controller.indicatorIndex.value,
                  effect: ScrollingDotsEffect(
                    activeDotColor: Get.theme.colorScheme.primary,
                    dotColor: const Color(0xffE4E5E7),
                    dotHeight: 6.w,
                    dotWidth: 6.w,
                  ),
                ),
              ),
            ],
          );
        } else if (featuredJobsStatus.isError) {
          // Show shimmer or an error message for failure
          // You might want a CustomLottie with a retry button here instead of just shimmer
          return const FeaturedJobShimmer();
        }
        // Fallback for any unhandled state (e.g., initial idle state if not loading, success, or error)
        return const SizedBox.shrink();
      },
    );
  }
}
