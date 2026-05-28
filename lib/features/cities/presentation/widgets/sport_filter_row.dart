import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/mock_cities_data.dart';
import '../../domain/models/sport_filter.dart';
import '../providers/cities_provider.dart';

/// Horizontal row of circular sport-image badges with their label below.
/// Selected sport gets a brand-coloured ring and brand-coloured text.
class SportFilterRow extends StatelessWidget {
  const SportFilterRow({super.key});

  static const _sports = kMockSports;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 108.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: _sports.length,
        itemBuilder: (_, i) => Padding(
          padding: EdgeInsets.only(right: i < _sports.length - 1 ? 8.w : 0),
          child: _SportTile(sport: _sports[i]),
        ),
      ),
    );
  }
}

class _SportTile extends StatelessWidget {
  const _SportTile({required this.sport});

  final SportFilter sport;

  @override
  Widget build(BuildContext context) {
    final selected = context.select<CitiesProvider, bool>(
      (p) => p.selectedSportId == sport.id,
    );
    return GestureDetector(
      onTap: () => context.read<CitiesProvider>().selectSport(sport.id),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 68.w,
        decoration: BoxDecoration(
          color: selected ? Color(0xffF8EDED) : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: selected ? AppColors.brand : Colors.transparent,
            width: 1.5,
          ),
        ),
        padding: EdgeInsets.only(top: 8.h, left: 3.w, right: 3.w, bottom: 3.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              sport.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                color: selected ? AppColors.brand : AppColors.textPrimary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
              ),
            ),
            SizedBox(height: 6.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: SizedBox(
                width: 65.r,
                height: 65.r,
                child: Image.network(
                  sport.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    color: AppColors.lightGrey,
                    child: Icon(
                      Icons.sports_soccer_rounded,
                      color: AppColors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
