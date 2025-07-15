import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jobs_flutter_app/app/core/values/strings.dart';

import '../../../../routes/app_pages.dart';
import '../../../../data/remote/api/api_routes.dart';
import '../../../../widgets/custom_lottie.dart';
import '../../controllers/search_controller.dart' as local;
import 'items_card.dart';

class SearchResults extends GetView<local.SearchController> {
  const SearchResults({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.rxResults.when(
        idle: () => Container(),
        loading: () => const Center(child: CircularProgressIndicator()),
        success: (results) => results!.isEmpty
            ? CustomLottie(
                title: AppStrings.NO_RESULT,
                asset: "assets/empty.json",
                description:AppStrings.NO_RESULT_DES,
                assetHeight: 200.h,
              )
            : ListView.builder(
                itemCount: results.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: SearchItem(
                    avatar: "${ApiRoutes.BASE_URL}${results[index].image}",
                    title: results[index].name!,
                    subtitle: "Internet company",
                    onTap: () => Get.toNamed(Routes.COMPANY_PROFILE,
                        arguments: results[index].id!),
                  ),
                ),
              ),
        failure: (e) => CustomLottie(
          asset: "assets/space.json",
          title: e!,
          onTryAgain: controller.onRetry,
        ),
      ),
    );
  }
}
