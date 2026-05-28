import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/router/app_routes.dart';
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

/// Cities tab — the host-city discovery hub.
///
/// Vertical scroll composed of: sport filter, league filter, host-city
/// count + carousel, then three horizontal carousels (Miami Fans,
/// Miami FanPages, Miami Matches).
///
/// Implementation note: every scroll uses `ListView.builder` (vertical
/// page sections + horizontal carousels) so each row/card is lazily
/// instantiated. This keeps the screen cheap when any of the underlying
/// data sources grows.
class CitiesScreen extends StatelessWidget {
  const CitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomGap = MediaQuery.of(context).padding.bottom + 30.h;

    // The vertical page is a fixed sequence of sections, but we still
    // route it through `ListView.builder` so off-screen sections are
    // built lazily as the user scrolls.
    final sections = <Widget Function()>[
      () => const SportFilterRow(),
      () => SizedBox(height: 12.h),
      () => const LeagueFilterRow(),
      () => SizedBox(height: 20.h),
      _hostCitiesHeader,
      () => SizedBox(height: 12.h),
      () => const HostCityCarousel(),
      () => SizedBox(height: 24.h),
      () => SectionHeader(
        title: AppStrings.sectionMiamiFans,
        onViewAll: () => Navigator.pushNamed(context, AppRoutes.miamiFans),
      ),
      () => SizedBox(height: 12.h),
      _miniFansList,
      () => SizedBox(height: 24.h),
      () => SectionHeader(
        title: AppStrings.sectionMiamiFanPages,
        onViewAll: () => Navigator.pushNamed(context, AppRoutes.miamiFanPages),
      ),
      () => SizedBox(height: 12.h),
      _fanPagesList,
      () => SizedBox(height: 24.h),
      () => SectionHeader(
        title: AppStrings.sectionMiamiMatches,
        onViewAll: () => Navigator.pushNamed(context, AppRoutes.miamiMatches),
      ),
      () => SizedBox(height: 12.h),
      _matchesList,
    ];

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: const CitiesAppBar(),
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: ListView.builder(
          padding: EdgeInsets.only(top: 8.h, bottom: bottomGap),
          itemCount: sections.length,
          itemBuilder: (_, i) => sections[i](),
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
          color: Color(0xffA6A5A5),
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
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: kMockFanProfiles.length,
        itemBuilder: (_, i) => Padding(
          padding: EdgeInsets.only(
            right: i < kMockFanProfiles.length - 1 ? 12.w : 0,
          ),
          child: MiniFanCard(profile: kMockFanProfiles[i]),
        ),
      ),
    );
  }

  Widget _fanPagesList() {
    return SizedBox(
      height: 270.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: kMockFanPages.length,
        itemBuilder: (_, i) => Padding(
          padding: EdgeInsets.only(
            right: i < kMockFanPages.length - 1 ? 12.w : 0,
          ),
          child: FanPageCard(fanPage: kMockFanPages[i]),
        ),
      ),
    );
  }

  Widget _matchesList() {
    return SizedBox(
      height: 210.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: kMockMatches.length,
        itemBuilder: (_, i) => Padding(
          padding: EdgeInsets.only(
            right: i < kMockMatches.length - 1 ? 12.w : 0,
          ),
          child: MatchCard(fixture: kMockMatches[i]),
        ),
      ),
    );
  }
}
