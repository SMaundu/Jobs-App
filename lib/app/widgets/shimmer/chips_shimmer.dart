import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ChipsShimmer extends StatelessWidget {
  const ChipsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    // The error "Horizontal viewport was given unbounded height" occurs because a
    // horizontal ListView needs a specific height when it's inside a widget
    // that doesn't provide one (like a Column).
    // Wrapping it in a SizedBox with a defined height resolves this.
    return SizedBox(
      height: 50.h,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (_, __) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Chip(
              backgroundColor: Colors.white,
              label: SizedBox(width: 60.w, height: 24.h),
            ),
          ),
        ),
      ),
    );
  }
}