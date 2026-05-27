import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';

/// Top bar for the Cities tab: "Host Cities" title on the left, profile
/// avatar (with online dot) on the right.
class CitiesAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CitiesAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.scaffoldBackground,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 56.h,
      titleSpacing: 0,
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: [
            Text(
              AppStrings.hostCitiesTitle,
              style: GoogleFonts.inter(
                color: AppColors.textPrimary,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.4,
              ),
            ),
            const Spacer(),
            _avatar(),
          ],
        ),
      ),
    );
  }

  Widget _avatar() {
    return Stack(
      children: [
        CircleAvatar(
          radius: 22.r,
          backgroundImage: const NetworkImage(
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100&auto=format',
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: 12.r,
            height: 12.r,
            decoration: BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
