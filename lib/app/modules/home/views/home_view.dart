import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobs_flutter_app/app/data/remote/base/status.dart';

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
        appBar: CustomAppBar( // The Builder widget provides a new context that is a descendant of the Scaffold.
          leading: Builder(
            builder: (context) => Padding(
              padding: EdgeInsets.only(left: 16.w, bottom: 8.w, top: 8.w),
              child: GestureDetector(
                onTap: () => Scaffold.of(context).openDrawer(),
                child: Obx(() {
                  return controller.customerAvatar.when(
                      idle: () => CircleAvatar(radius: 23.h),
                      loading: () => CircleAvatar(radius: 23.h),
                      success: (data) => CustomAvatar(
                            imageUrl: "${ApiRoutes.BASE_URL}$data",
                            height: 46.h,
                          ),
                      failure: (error) => CircleAvatar(radius: 23.h));
                }),
              ),
            ),
          ),
          title: "Job Finder",
        ),
        body: Obx(() {
          final bool isLoading = controller.featuredJobs is Loading ||
              controller.recentJobs is Loading ||
              controller.positions is Loading;

          final bool hasError = controller.featuredJobs is Failure ||
              controller.recentJobs is Failure ||
              controller.positions is Failure;

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
