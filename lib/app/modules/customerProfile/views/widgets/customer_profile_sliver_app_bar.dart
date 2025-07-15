import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';

import '../../../../data/remote/dto/customer/customer_profile_out_dto.dart';
import '../../controllers/customer_profile_controller.dart';
import 'header.dart';

class CustomerProfileSliverAppBar extends GetView<CustomerProfileController> {
  const CustomerProfileSliverAppBar({Key? key, required this.profile})
      : super(key: key);
  final CustomerProfileOutDto profile;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      expandedHeight: 210.h,
      backgroundColor: Get.theme.primaryColor,
      pinned: true,
      leadingWidth: kToolbarHeight,
      toolbarHeight: kToolbarHeight,
      leading: Padding(
        padding: EdgeInsets.all(6.w),
        child: IconButton(
          onPressed: () => Get.back(),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white.withOpacity(0.2),
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          icon: const HeroIcon(
            HeroIcons.chevronLeft,
            color: Colors.white,
          ),
        ),
      ),
      centerTitle: true,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.surface,
      ),
      title: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: const Text("Profile"),
      ),
      actions: [
        Container(
          width: 50.w,
          height: 50.w,
          padding: EdgeInsets.all(6.w),
          child: IconButton(
            onPressed: () {},
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.2),
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            icon: const HeroIcon(
              HeroIcons.pencilSquare,
              color: Colors.white,
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Header(profile: profile),
      ),
    );
  }
}
