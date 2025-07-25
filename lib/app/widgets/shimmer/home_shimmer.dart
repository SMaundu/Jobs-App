import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'chips_shimmer.dart';
import 'featured_job_shimmer.dart';
import 'recent_jobs_shimmer.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            const FeaturedJobShimmer(),
            SizedBox(height: 32.h),
            const ChipsShimmer(),
            SizedBox(height: 32.h),
            const RecentJobsShimmer(),
          ],
        ),
      ),
    );
  }
}