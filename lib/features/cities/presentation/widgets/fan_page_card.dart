import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/fan_page.dart';

/// Large rounded card surfaced in the "Miami FanPages" carousel.
///
/// A cover image fills the card, a dark gradient anchors the text at
/// the bottom: fan-count pill, page name with optional verified tick,
/// short subtitle, and a "Follow" button.
class FanPageCard extends StatelessWidget {
  const FanPageCard({super.key, required this.fanPage, this.onFollow});

  final FanPage fanPage;
  final VoidCallback? onFollow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280.w,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(24.r)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              fanPage.coverUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) =>
                  Container(color: AppColors.lightGrey),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color(0x99000000),
                    Colors.black,
                  ],
                  stops: [0.35, 0.75, 1.0],
                ),
              ),
            ),
            Positioned(
              left: 16.w,
              right: 16.w,
              bottom: 16.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _fansPill(),
                  SizedBox(height: 8.h),
                  _nameRow(),
                  SizedBox(height: 4.h),
                  Text(
                    fanPage.subtitle,
                    style: GoogleFonts.inter(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _followButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fansPill() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.group_rounded, color: Colors.white, size: 12.r),
          SizedBox(width: 6.w),
          Text(
            fanPage.fansLabel,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _nameRow() {
    return Row(
      children: [
        Flexible(
          child: Text(
            fanPage.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
        ),
        if (fanPage.verified) ...[
          SizedBox(width: 6.w),
          Icon(Icons.verified_rounded, color: Colors.white, size: 16.r),
        ],
      ],
    );
  }

  Widget _followButton() {
    return GestureDetector(
      onTap: onFollow,
      child: Container(
        height: 38.h,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(12.r),
        ),
        alignment: Alignment.center,
        child: Text(
          AppStrings.follow,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
