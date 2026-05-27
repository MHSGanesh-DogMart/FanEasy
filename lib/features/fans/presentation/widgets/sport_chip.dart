import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// Frosted-glass chip used to surface a profile's sport interest.
class SportChip extends StatelessWidget {
  const SportChip({super.key, required this.label});

  final String label;

  IconData get _icon {
    if (label.contains('⚽')) return Icons.sports_soccer_rounded;
    if (label.contains('🏈') || label.contains('🏉')) {
      return Icons.sports_rugby_rounded;
    }
    return Icons.sports_basketball_rounded;
  }

  String get _cleanLabel => label.replaceAll(RegExp(r'[^\w\s]'), '').trim();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: 26.h,
          padding: EdgeInsets.only(
            top: 4.h,
            right: 8.w,
            bottom: 4.h,
            left: 7.w,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_icon, color: Colors.white, size: 13.r),
              SizedBox(width: 4.w),
              Text(
                _cleanLabel,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.14,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
