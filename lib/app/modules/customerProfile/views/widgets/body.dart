import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../widgets/shimmer/customer_profile_shimmer.dart';
import '../../controllers/customer_profile_controller.dart';
import 'about_me.dart';
import 'customer_profile_sliver_app_bar.dart';
import 'education.dart';
import 'experience.dart';
import 'languages.dart';
import 'skills.dart';

class Body extends GetView<CustomerProfileController> {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final profileStatus = controller.profile; // Get the Status object

        if (profileStatus.isLoading) {
          return const CustomerProfileShimmer(); // Show shimmer for loading
        } else if (profileStatus.isError) {
          // Show shimmer or an error message for failure
          return const CustomerProfileShimmer(); // Or a CustomLottie with retry
        } else if (profileStatus.isSuccess) {
          final profile = profileStatus.data; // Access data directly

          if (profile == null) {
            // Handle case where profile data is null even if status is success
            return const Center(child: Text("Profile data not available."));
          }

          return CustomScrollView(
            slivers: [
              CustomerProfileSliverAppBar(profile: profile), // profile is now non-nullable here
              SliverToBoxAdapter(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(top: 16.h),
                    child: Column(
                      children: [
                        AboutMe(description: profile.description), // Use updated description field
                        Experience(experience: profile.workExperience),
                        EducationCard(education: profile.education),
                        Skills(skills: profile.skills),
                        Languages(languages: profile.language), // Use updated language field
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        // Fallback for any unhandled status (e.g., initial idle state if not loading, success, or error)
        return const SizedBox.shrink();
      },
    );
  }
}
