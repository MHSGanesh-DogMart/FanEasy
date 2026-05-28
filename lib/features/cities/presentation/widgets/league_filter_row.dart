import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/mock_cities_data.dart';
import '../../domain/models/league.dart';
import '../providers/cities_provider.dart';

/// Pill-shaped league filter row.
/// Selected: brand border + brand text on white.
/// Unselected: light-grey fill, secondary text, no border.
class LeagueFilterRow extends StatelessWidget {
  const LeagueFilterRow({super.key});

  static const _leagues = kMockLeagues;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: _leagues.length,
        itemBuilder: (_, i) => Padding(
          padding: EdgeInsets.only(right: i < _leagues.length - 1 ? 8.w : 0),
          child: _LeaguePill(league: _leagues[i]),
        ),
      ),
    );
  }
}

class _LeaguePill extends StatelessWidget {
  const _LeaguePill({required this.league});

  final League league;

  @override
  Widget build(BuildContext context) {
    final selected = context.select<CitiesProvider, bool>(
      (p) => p.selectedLeagueId == league.id,
    );
    return GestureDetector(
      onTap: () => context.read<CitiesProvider>().selectLeague(league.id),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.brandSoft : Color(0xffF2F2ED),
          borderRadius: BorderRadius.circular(100.r),
          border: Border.all(
            color: selected ? AppColors.brand : const Color(0xffEBEAEA),
            width: 1.5,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          league.label,
          style: GoogleFonts.inter(
            color: selected ? AppColors.brand : const Color(0xff626060),
            fontSize: 13.sp,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
