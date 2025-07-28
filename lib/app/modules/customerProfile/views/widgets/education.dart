import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';

import '../../../../data/remote/dto/customer/customer_profile_out_dto.dart'; // Import to access Education class
import '../../../../utils/extensions.dart'; // Assuming toShortDate() is defined here
import '../../../../widgets/custom_info_card.dart';

class EducationCard extends StatelessWidget {
  const EducationCard({
    Key? key,
    required this.education,
  }) : super(key: key);
  final List<Education>? education;

  @override
  Widget build(BuildContext context) {
    // Check if education list is null or empty before rendering
    return education == null || education!.isEmpty
        ? const SizedBox()
        : CustomInfoCard(
            icon: HeroIcons.academicCap,
            title: "Education",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                education!.length, // Safely access length after null check
                (index) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // Use null-aware operator and provide fallback empty string
                      education![index].degree ?? '',
                      style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: Get.theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      // Corrected from 'school' to 'institution'
                      // Use null-aware operator and provide fallback empty string
                      education![index].institution ?? '',
                      style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: Get.theme.colorScheme.secondary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      // Use null-aware operator for startDate and endDate before toShortDate()
                      "${education![index].startDate?.toShortDate() ?? ''} - ${education![index].endDate?.toShortDate() ?? ''}",
                      style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: Get.theme.colorScheme.secondary,
                      ),
                    ),
                    // Add a Divider between items, but not after the last one
                    if (index != education!.length - 1)
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
