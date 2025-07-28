import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/custom_lottie.dart';
import '../../../../widgets/shimmer/recent_jobs_shimmer.dart';
import '../../controllers/saved_controller.dart';
import 'no_saving.dart';
import 'saved_jobs.dart';

class Body extends GetView<SavedController> {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final status = controller.savedJobs; // Get the current status

        if (status.isLoading) {
          return const Center(child: RecentJobsShimmer()); // Show shimmer for loading
        } else if (status.isSuccess) {
          final data = status.data; // Access data directly

          if (data == null || data.isEmpty) {
            return const NoSaving();
          }
          return SavedJobs(jobs: data);
        } else if (status.isError) {
          // Access message directly
          return CustomLottie(
            asset: "assets/space.json",
            repeat: true,
            title: status.message ?? "An unexpected error occurred.", // Use status.message
            onTryAgain: controller.onRetry,
          );
        }
        // Fallback for any unhandled state (e.g., initial state if not loading, success, or error)
        return const SizedBox.shrink(); // Or a default widget
      },
    );
  }
}
