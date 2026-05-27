import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/host_city.dart';

/// Big rounded card showing a host-city cover photo, the city name with
/// a country flag, "Host City" subtitle, and three stats at the bottom.
///
/// Sits inside a `PageView` so multiple cities can be swiped through.
class HostCityCard extends StatelessWidget {
  const HostCityCard({super.key, required this.city});

  final HostCity city;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28.r),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            city.coverUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(color: AppColors.lightGrey),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Color(0x66000000),
                  Color(0xCC000000),
                ],
                stops: [0.4, 0.7, 1.0],
              ),
            ),
          ),
          Positioned(
            left: 20.w,
            right: 20.w,
            bottom: 20.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _flagPill(),
                SizedBox(height: 10.h),
                _nameRow(),
                SizedBox(height: 2.h),
                Text(
                  AppStrings.hostCitySubtitle,
                  style: GoogleFonts.inter(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 16.h),
                _statsRow(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _flagPill() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(city.flag, style: TextStyle(fontSize: 12.sp)),
          SizedBox(width: 6.w),
          Text(
            'USA',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _nameRow() {
    return Row(
      children: [
        Text(
          city.name,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 28.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            height: 1.1,
          ),
        ),
        SizedBox(width: 6.w),
        Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Colors.white,
          size: 24.r,
        ),
      ],
    );
  }

  Widget _statsRow() {
    return Row(
      children: [
        Expanded(
          child: _stat(city.fansVisiting, AppStrings.statFansVisiting),
        ),
        _divider(),
        Expanded(
          child: _stat('${city.fanPages}', AppStrings.statFanPages),
        ),
        _divider(),
        Expanded(
          child: _stat('${city.matches}', AppStrings.statMatches),
        ),
      ],
    );
  }

  Widget _divider() => Container(
        width: 1,
        height: 28.h,
        color: Colors.white.withValues(alpha: 0.25),
      );

  Widget _stat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.white.withValues(alpha: 0.85),
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
