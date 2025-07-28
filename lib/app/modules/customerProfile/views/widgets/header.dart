import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/remote/dto/customer/customer_profile_out_dto.dart';
import '../../../../widgets/custom_avatar.dart';
import '../../../../data/remote/api/api_routes.dart'; // Ensure ApiRoutes is imported
import '../../../JobDetails/controllers/job_details_controller.dart'; // Ensure this import is correct

class Header extends GetView<JobDetailsController> {
  const Header({
    Key? key,
    required this.profile,
  }) : super(key: key);
  final CustomerProfileOutDto profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 16.w, left: 16.w, top: 30.h),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: Svg('assets/header_bg.svg', color: Colors.white), // Ensure asset path is correct
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 30.h),
        child: Column(
          children: [
            // Use profile.avatar and provide a placeholder if null
            CustomAvatar(imageUrl: "${ApiRoutes.BASE_URL}${profile.avatar ?? 'placeholder.png'}"),
            SizedBox(height: 5.h),
            Text(
              // Use null-aware operator and provide fallback empty string
              profile.name ?? '',
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Get.theme.colorScheme.onPrimary,
              ),
            ),
            Text(
              // Use null-aware operator and provide fallback empty string for the new jobTitle field
              profile.jobTitle ?? '',
              style: GoogleFonts.poppins(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: Get.theme.colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
