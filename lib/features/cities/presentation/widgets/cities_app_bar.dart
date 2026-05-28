import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';

/// Top bar for the Cities tab: "Host Cities" title on the left, profile
/// avatar on the right.
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
            // const Spacer(),
          ],
        ),
      ),
      actions: [
        Row(
          children: [
            _avatar(),
            SizedBox(width: 20.w),
          ],
        ),
      ],
    );
  }

  Widget _avatar() {
    return Container(
      width: 44.r,
      height: 44.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: ClipOval(
        child: Image.network(
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100&auto=format',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
