import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobs_flutter_app/app/core/values/strings.dart';
import '../../../../routes/app_pages.dart';
import '../../../../data/remote/api/api_routes.dart';
import '../../../../widgets/custom_lottie.dart';
import '../../controllers/search_controller.dart' as local;
import 'items_card.dart';
import '../../../../data/remote/base/status.dart'; // Ensure Status class is imported

class SearchResults extends GetView<local.SearchController> {
  const SearchResults({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final status = controller.rxResults; // Get the current status

        if (status.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (status.isSuccess) {
          final results = status.data; // Access data directly

          if (results == null || results.isEmpty) {
            return CustomLottie(
              title: AppStrings.NO_RESULT,
              asset: "assets/empty.json",
              description: AppStrings.NO_RESULT_DES,
              assetHeight: 200.h,
            );
          } else {
            return ListView.builder(
              itemCount: results.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: SearchItem(
                  // Use null-aware operators for safety
                  avatar: "${ApiRoutes.BASE_URL}${results[index].image ?? 'placeholder.png'}",
                  title: results[index].name ?? '',
                  subtitle: "Internet company", // This seems to be a hardcoded string
                  onTap: () => Get.toNamed(
                    Routes.COMPANY_PROFILE,
                    arguments: results[index].id ?? '', // Provide fallback
                  ),
                ),
              ),
            );
          }
        } else if (status.isError) {
          // Access message directly
          return CustomLottie(
            asset: "assets/space.json",
            title: status.message ?? "An error occurred", // Use status.message
            onTryAgain: controller.onRetry,
          );
        }
        // Fallback for any unhandled state (e.g., initial state if not loading)
        return Container();
      },
    );
  }
}
