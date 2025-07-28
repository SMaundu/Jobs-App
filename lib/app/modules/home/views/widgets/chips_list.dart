import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/remote/base/status.dart'; // Ensure Status class is imported
import '../../../../widgets/shimmer/chips_shimmer.dart';
import '../../controllers/home_controller.dart';
import '../../../../data/remote/dto/position/position_out_dto.dart'; // Ensure PositionOutDto is imported

class ChipsList extends GetView<HomeController> {
  const ChipsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final positionsStatus = controller.positions; // Get the current status

        if (positionsStatus.isLoading) {
          return const ChipsShimmer(); // Show shimmer for loading
        } else if (positionsStatus.isSuccess) {
          final positions = positionsStatus.data; // Access data directly

          if (positions == null || positions.isEmpty) {
            return const SizedBox.shrink(); // Or a message indicating no positions
          }

          return SizedBox(
            height: 40.h,
            child: ListView.builder(
              itemCount: positions.length,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final position = positions[index];
                return Obx(
                  () => GestureDetector(
                    // Changed from position.title to position.name
                    onTap: () => controller.updateChipTitle(position.name ?? ''),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      margin: EdgeInsets.only(right: 10.w),
                      decoration: BoxDecoration(
                        // Changed from position.title to position.name
                        color: controller.chipTitle.value == (position.name ?? '')
                            ? Get.theme.colorScheme.primary
                            : Get.theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Center(
                        child: Text(
                          position.name ?? '', // Changed from position.title to position.name
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            // Changed from position.title to position.name
                            color: controller.chipTitle.value == (position.name ?? '')
                                ? Get.theme.colorScheme.onPrimary
                                : Get.theme.colorScheme.secondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else if (positionsStatus.isError) {
          // You might want a CustomLottie with a retry button here instead of just shimmer
          return const SizedBox.shrink(); // Or an error message/retry button
        }
        // Fallback for any unhandled state (e.g., initial idle state if not loading, success, or error)
        return const SizedBox.shrink();
      },
    );
  }
}
