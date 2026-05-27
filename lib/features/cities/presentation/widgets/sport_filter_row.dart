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
      height: 92.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: _sports.length,
        separatorBuilder: (_, _) => SizedBox(width: 14.w),
        itemBuilder: (_, i) => _SportTile(sport: _sports[i]),
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
      child: SizedBox(
        width: 60.r,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.all(2.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppColors.brand : Colors.transparent,
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                radius: 26.r,
                backgroundImage: NetworkImage(sport.imageUrl),
                backgroundColor: AppColors.lightGrey,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              sport.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                color: selected ? AppColors.brand : AppColors.textPrimary,
                fontSize: 12.sp,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
