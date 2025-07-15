import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';

class CustomInfoCard extends StatelessWidget {
  const CustomInfoCard({
    Key? key,
    required this.child,
    required this.icon,
    required this.title,
    this.action,
    this.onActionTap,
  }) : super(key: key);
  final Widget child;
  final HeroIcons icon;
  final HeroIcons? action;
  final String title;
  final void Function()? onActionTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      margin: EdgeInsets.only(bottom: 16.h, right: 16.w, left: 16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              HeroIcon(
                icon,
                color: Get.theme.colorScheme.primary,
              ),
              SizedBox(width: 10.w),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: Get.theme.colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              if (action != null)
                GestureDetector(
                  onTap: onActionTap,
                  child: HeroIcon(action!),
                )
            ],
          ),
          SizedBox(height: 10.h),
          Divider(
            color: Get.theme.colorScheme.surface,
            thickness: 1.5,
          ),
          SizedBox(height: 10.h),
          child,
        ],
      ),
    );
  }
}
