import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jobs_flutter_app/app/data/remote/base/status.dart'; // Ensure this points to your standard Status class

import '../../../data/remote/api/api_routes.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_avatar.dart';
import '../../../widgets/shimmer/home_shimmer.dart';
import '../controllers/home_controller.dart';
import 'widgets/body.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: CustomAppBar(
          leading: Builder(
            builder: (context) => Padding(
              padding: EdgeInsets.only(left: 16.w, bottom: 8.w, top: 8.w),
              child: GestureDetector(
                onTap: () => Scaffold.of(context).openDrawer(),
                child: Obx(() {
                  // Using the custom getters from the Status class
                  if (controller.customerAvatar.isLoading) {
                    return CircleAvatar(radius: 23.h);
                  } else if (controller.customerAvatar.isSuccess) {
                    final data = controller.customerAvatar.data;
                    return CustomAvatar(
                      imageUrl: "${ApiRoutes.BASE_URL}${data ?? 'placeholder.png'}", // Provide placeholder if data is null
                      height: 46.h,
                    );
                  } else {
                    // Handle error or any other state by showing a default avatar
                    return CircleAvatar(radius: 23.h);
                  }
                }),
              ),
            ),
          ),
          title: "Job Finder",
        ),
        body: Obx(() {
          // Using the custom getters from the Status class
          final bool isLoading = controller.featuredJobs.isLoading ||
              controller.recentJobs.isLoading ||
              controller.positions.isLoading;

          final bool hasError = controller.featuredJobs.isError ||
              controller.recentJobs.isError ||
              controller.positions.isError;

          if (isLoading) {
            return const HomeShimmer();
          }

          if (hasError) {
            return Center(
              child: ElevatedButton(
                  onPressed: controller.loadHomeData, child: const Text("Retry")),
            );
          }

          return const Body();
        }),
      ),
    );
  }
}
