import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../widgets/shimmer/company_profile_shimmer.dart';
import '../../controllers/company_profile_controller.dart';
import 'company_profile_sliver_app_bar.dart';
import 'company_tab_view.dart';
import 'sliverPersistentHeaderDelegateImp.dart';
import '../../../../data/remote/base/status.dart'; // Ensure Status class is imported

class Body extends GetView<CompanyProfileController> {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final companyStatus = controller.rxCompany; // Get the Status object

        if (companyStatus.isLoading) {
          return const CompanyProfileShimmer(); // Show shimmer for loading
        } else if (companyStatus.isError) {
          // Show shimmer or an error message for failure
          return const CompanyProfileShimmer(); // Or a CustomLottie with retry option
        } else if (companyStatus.isSuccess) {
          final company = companyStatus.data; // Access data directly

          if (company == null) {
            // Handle case where company data is null even if status is success
            return const Center(child: Text("Company data not available."));
          }

          return NestedScrollView(
            headerSliverBuilder: (
              BuildContext context,
              bool innerBoxIsScrolled,
            ) {
              return <Widget>[
                CompanyProfileSliverAppBar(company: company), // company is now non-nullable here
                SliverPersistentHeader(
                  delegate: SliverPersistentHeaderDelegateImp(
                    tabBar: TabBar(
                      controller: controller.tabController,
                      labelStyle: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      unselectedLabelStyle: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      labelColor: Get.theme.colorScheme.onPrimary,
                      unselectedLabelColor: Get.theme.colorScheme.secondary,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: Get.theme.colorScheme.primary,
                      ),
                      tabs: const [
                        Tab(text: "About us"),
                        Tab(text: "Jobs"),
                      ],
                    ),
                  ),
                  pinned: true,
                ),
              ];
            },
            body: const CompanyTabView(),
          );
        }
        // Fallback for any unhandled status (e.g., initial idle state if not loading, success, or error)
        return const SizedBox.shrink();
      },
    );
  }
}
