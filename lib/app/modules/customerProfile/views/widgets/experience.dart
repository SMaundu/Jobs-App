import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';

import '../../../../data/remote/dto/customer/customer_profile_out_dto.dart'; // <-- ADD THIS IMPORT
import '../../../../utils/extensions.dart'; // Assuming toShortDate() is defined here
import '../../../../widgets/custom_info_card.dart';

class Experience extends StatelessWidget {
  const Experience({
    Key? key,
    required this.experience,
  }) : super(key: key);
  final List<WorkExperience>? experience;

  @override
  Widget build(BuildContext context) {
    // Check if experience list is null or empty before rendering
    return experience == null || experience!.isEmpty
        ? const SizedBox()
        : CustomInfoCard(
            icon: HeroIcons.briefcase,
            title: "Work experience",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                experience!.length, // Safely access length after null check
                (index) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // Use null-aware operator and provide fallback empty string
                      experience![index].title ?? '',
                      style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: Get.theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      // Use null-aware operator and provide fallback empty string
                      experience![index].companyWorkedFor ?? '',
                      style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: Get.theme.colorScheme.secondary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      // Use null-aware operator for startDate and endDate before toShortDate()
                      "${experience![index].startDate?.toShortDate() ?? ''} - ${experience![index].endDate?.toShortDate() ?? ''}",
                      style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: Get.theme.colorScheme.secondary,
                      ),
                    ),
                    // Add a Divider between items, but not after the last one
                    if (index != experience!.length - 1)
                      Divider(
                        color: Get.theme.colorScheme.surface,
                        thickness: 1.5,
                      ),
                  ],
                ),
              ),
            ),
          );
  }
}
