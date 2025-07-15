import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    this.leading,
    this.title,
    this.actions,
    this.backgroundColor,
  }) : super(key: key);
  final Widget? leading;
  final List<Widget>? actions;
  final String? title;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: 0.0,
      leading: leading,
      title: title != null
          ? Text(
              title!,
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: Get.theme.colorScheme.onSurface,
              ),
            )
          : null,
      centerTitle: true,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
