import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';

import '../../../../data/remote/api/api_routes.dart';
import '../../../../data/remote/dto/job/job_out_dto.dart';
import '../../../../routes/app_pages.dart';
import '../../../../widgets/custom_job_card.dart';
import '../../controllers/saved_controller.dart';

class SavedJobs extends GetView<SavedController> {
  const SavedJobs({
    Key? key,
    required this.jobs,
  }) : super(key: key);
  final List<JobOutDto> jobs;

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: controller.animatedListKey,
      initialItemCount: jobs.length,
      controller: controller.savedScrollController,
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index, animation) {
        final job = jobs[index]; // Get the current job for easier access

        return CustomJobCard(
          // Safely access company image. Use a placeholder if company or image is null.
          avatar: "${ApiRoutes.BASE_URL}${job.company?.image ?? 'placeholder.png'}",
          // Safely access company name. Provide empty string if company or name is null.
          companyName: job.company?.name ?? '',
          // Safely access employmentType. Provide empty string if null.
          employmentType: job.employmentType ?? '',
          // Safely access jobPosition. Provide empty string if null.
          jobPosition: job.position ?? '',
          // Safely access location. Provide empty string if null.
          location: job.location ?? '',
          actionIcon: HeroIcons.bookmark,
          isSaved: true,
          // Safely access createdAt and format it. Provide empty string if null.
          publishTime: job.createdAt?.toIso8601String() ?? '', // Or format as desired, e.g., DateFormat('MMM dd, yyyy').format(job.createdAt!)
          // Safely access workplace. Provide empty string if null.
          workplace: job.workplace ?? '',
          // Safely access description. Provide empty string if null.
          description: job.description ?? '',
          onActionTap: (isSaved) =>
              controller.onSaveButtonTapped(isSaved, job.id ?? ''), // Provide empty string if id is null
          onAvatarTap: () => Get.toNamed(
            Routes.COMPANY_PROFILE,
            arguments: job.company?.id ?? '', // Provide empty string if company or id is null
          ),
          onTap: () => Get.toNamed(
            Routes.JOB_DETAILS,
            arguments: job.id ?? '', // Provide empty string if id is null
          ),
        );
      },
    );
  }
}
