import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_strings.dart';
import '../../data/mock_cities_data.dart';
import '../../domain/models/match_fixture.dart';

/// Screen displaying all match fixtures for Miami.
/// Accessible by tapping "View all" next to Miami Matches.
class MiamiMatchesScreen extends StatelessWidget {
  const MiamiMatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Generate a long list by duplicating mock fixtures to ensure scrollability
    final matches = List.generate(6, (index) => kMockMatches[index % kMockMatches.length]);

    return Scaffold(
      backgroundColor: const Color(0xffFAF9F6),
      appBar: AppBar(
        backgroundColor: const Color(0xffFAF9F6),
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 70.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 16.w, top: 6.h, bottom: 6.h),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x1A000000),
                    offset: Offset(0, 2),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Icon(
                Icons.chevron_left_rounded,
                color: Colors.black,
                size: 26.r,
              ),
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          'Miami Matches',
          style: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          itemCount: matches.length,
          separatorBuilder: (_, index) => SizedBox(height: 16.h),
          itemBuilder: (context, index) {
            return _CustomMatchCard(fixture: matches[index]);
          },
        ),
      ),
    );
  }
}

/// Custom high-fidelity match card defined locally to avoid modifying shared widgets.
class _CustomMatchCard extends StatelessWidget {
  const _CustomMatchCard({required this.fixture});

  final MatchFixture fixture;

  @override
  Widget build(BuildContext context) {
    final base = Color(fixture.accent);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.white, width: 2.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: Offset(0, 8.h),
            blurRadius: 16.r,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22.r),
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0.0, -0.6),
              radius: 1.2,
              colors: [
                Color.lerp(base, Colors.white, 0.18)!,
                base,
                Color.lerp(base, Colors.black, 0.35)!,
              ],
              stops: const [0.0, 0.55, 1.0],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _topRow(),
                SizedBox(height: 14.h),
                _teamsRow(),
                SizedBox(height: 20.h),
                _footer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _topRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.24),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.18),
              width: 1.w,
            ),
          ),
          child: Text(
            fixture.competition,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 10.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _teamsRow() {
    return Row(
      children: [
        Expanded(child: _team(fixture.homeTeam, fixture.homeLogoUrl)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Text(
            AppStrings.vs,
            style: GoogleFonts.inter(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        Expanded(child: _team(fixture.awayTeam, fixture.awayLogoUrl)),
      ],
    );
  }

  Widget _team(String code, String logoUrl) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 56.r,
          width: 56.r,
          child: Image.network(
            logoUrl,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => Icon(
              Icons.shield_outlined,
              color: Colors.white.withValues(alpha: 0.6),
              size: 40.r,
            ),
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          code,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _footer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          fixture.dateLabel,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 6.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 14.r,
              color: Colors.white.withValues(alpha: 0.9),
            ),
            SizedBox(width: 4.w),
            Flexible(
              child: Text(
                fixture.venue,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
