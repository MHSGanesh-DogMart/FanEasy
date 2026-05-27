import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../fans/domain/models/fan_profile.dart';

/// Compact profile card used in the "Miami Fans" horizontal carousel.
///
/// Photo background with a dark gradient at the bottom that hosts the
/// flag/country, name/age, sport + activity chips, and a pair of red /
/// green action buttons (heart + send).
class MiniFanCard extends StatelessWidget {
  const MiniFanCard({
    super.key,
    required this.profile,
    this.onLike,
    this.onSend,
  });

  final FanProfile profile;
  final VoidCallback? onLike;
  final VoidCallback? onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 165.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: AppColors.cardActionBg,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              profile.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) =>
                  Container(color: AppColors.cardActionBg),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color(0xCC000000),
                    Colors.black,
                  ],
                  stops: [0.35, 0.7, 1.0],
                ),
              ),
            ),
            Positioned(
              left: 10.w,
              right: 10.w,
              bottom: 10.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _flagRow(),
                  SizedBox(height: 2.h),
                  Text(
                    '${profile.name}, ${profile.age}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  _miniChips(profile.sports),
                  SizedBox(height: 4.h),
                  _miniChips(profile.activities),
                  SizedBox(height: 8.h),
                  _actionRow(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _flagRow() {
    return Row(
      children: [
        Text(profile.flag, style: TextStyle(fontSize: 12.sp)),
        SizedBox(width: 4.w),
        Text(
          profile.country.toUpperCase(),
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 10.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _miniChips(List<String> labels) {
    return Wrap(
      spacing: 4.w,
      runSpacing: 4.h,
      children: labels.take(2).map(_chip).toList(),
    );
  }

  Widget _chip(String label) {
    final clean = label.replaceAll(RegExp(r'[^\w\s]'), '').trim();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        clean,
        style: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _actionRow() {
    return Row(
      children: [
        Expanded(
          child: _smallActionBtn(
            color: AppColors.cardActionNope,
            icon: Icons.favorite_rounded,
            onTap: onLike,
          ),
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: _smallActionBtn(
            color: AppColors.cardActionSend,
            icon: Icons.send_rounded,
            onTap: onSend,
          ),
        ),
      ],
    );
  }

  Widget _smallActionBtn({
    required Color color,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32.h,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Center(
          child: Icon(icon, color: color, size: 16.r),
        ),
      ),
    );
  }
}
