import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../fans/data/mock_fan_profiles.dart';
import '../../data/mock_cities_data.dart';
import '../widgets/cities_app_bar.dart';
import '../widgets/fan_page_card.dart';
import '../widgets/host_city_carousel.dart';
import '../widgets/league_filter_row.dart';
import '../widgets/match_card.dart';
import '../widgets/mini_fan_card.dart';
import '../widgets/section_header.dart';
import '../widgets/sport_filter_row.dart';

/// Cities tab â€” the host-city discovery hub.
///
/// Vertical scroll composed of: sport filter, league filter, host-city
/// count + carousel, then three horizontal carousels (Miami Fans,
/// Miami FanPages, Miami Matches).
class CitiesScreen extends StatelessWidget {
  const CitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomGap = 16.h + MediaQuery.of(context).padding.bottom + 80.h;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: const CitiesAppBar(),
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.only(top: 8.h, bottom: bottomGap),
          children: [
            const SportFilterRow(),
            SizedBox(height: 12.h),
            const LeagueFilterRow(),
            SizedBox(height: 20.h),
            _hostCitiesHeader(),
            SizedBox(height: 12.h),
            const HostCityCarousel(),
            SizedBox(height: 24.h),
            SectionHeader(
              title: AppStrings.sectionMiamiFans,
              onViewAll: () {},
            ),
            SizedBox(height: 12.h),
            _miniFansList(),
            SizedBox(height: 24.h),
            SectionHeader(
              title: AppStrings.sectionMiamiFanPages,
              onViewAll: () {},
            ),
            SizedBox(height: 12.h),
            _fanPagesList(),
            SizedBox(height: 24.h),
            SectionHeader(
              title: AppStrings.sectionMiamiMatches,
              onViewAll: () {},
            ),
            SizedBox(height: 12.h),
            _matchesList(),
          ],
        ),
      ),
    );
  }

  Widget _hostCitiesHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Text(
        '${kMockHostCities.length} ${AppStrings.hostCitiesCount}',
        style: GoogleFonts.inter(
          color: AppColors.textPrimary,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
      ),
    );
  }

  Widget _miniFansList() {
    return SizedBox(
      height: 240.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: kMockFanProfiles.length,
        separatorBuilder: (_, _) => SizedBox(width: 12.w),
        itemBuilder: (_, i) => MiniFanCard(profile: kMockFanProfiles[i]),
      ),
    );
  }

  Widget _fanPagesList() {
    return SizedBox(
      height: 200.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: kMockFanPages.length,
        separatorBuilder: (_, _) => SizedBox(width: 12.w),
        itemBuilder: (_, i) => FanPageCard(fanPage: kMockFanPages[i]),
      ),
    );
  }

  Widget _matchesList() {
    return SizedBox(
      height: 210.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: kMockMatches.length,
        separatorBuilder: (_, _) => SizedBox(width: 12.w),
        itemBuilder: (_, i) => MatchCard(fixture: kMockMatches[i]),
      ),
    );
  }
}
