import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';

import '../../../../data/remote/api/api_routes.dart';
import '../../../../routes/app_pages.dart';
import '../../../../widgets/custom_job_card.dart';
import '../../../../widgets/custom_lottie.dart';
import '../../../saved/controllers/saved_controller.dart';
import '../../controllers/company_profile_controller.dart';

class JobsList extends GetView<CompanyProfileController> {
  const JobsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Removed .value because controller.rxJobs is already the Status object
      final status = controller.rxJobs; 

      if (status.isLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (status.isError) {
        return Center(child: Text(status.message ?? "An unknown error occurred."));
      } else if (status.isSuccess) {
        final jobs = status.data; // Access the data from the status

        if (jobs == null || jobs.isEmpty) {
          return const CustomLottie(
            title: "This company has no jobs yet.",
            asset: "assets/empty.json", // Ensure this asset path is correct
          );
        } else {
          return ListView.builder(
            itemCount: jobs.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(), // Added to prevent nested scrolling issues
            itemBuilder: (context, index) {
              final job = jobs[index]; // Get the current job for easier access

              return CustomJobCard(
                jobPosition: job.position ?? '', // Null-safe access
                publishTime: job.createdAt?.toIso8601String() ?? '', // Null-safe access and formatting
                companyName: job.company?.name ?? '', // Null-safe access
                employmentType: job.employmentType ?? '', // Null-safe access
                location: job.location ?? '', // Null-safe access
                workplace: job.workplace ?? '', // Null-safe access
                actionIcon: HeroIcons.bookmark,
                avatar: "${ApiRoutes.BASE_URL}${job.company?.image ?? 'placeholder.png'}", // Null-safe access with placeholder
                description: job.description ?? '', // Null-safe access
                onTap: () => Get.toNamed(
                  Routes.JOB_DETAILS,
                  arguments: job.id ?? '', // Null-safe access
                ),
                // Ensure SavedController is initialized and accessible
                isSaved: SavedController.to.isJobSaved(job.id ?? ''), // Null-safe access
                onActionTap: (isSaved) =>
                    controller.onSaveButtonTapped(isSaved, job.id ?? ''), // Null-safe access
              );
            },
          );
        }
      }
      return Container(); // Fallback for any unhandled status
    });
  }
}
