import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_strings.dart';
import '../../domain/models/match_fixture.dart';

/// Card used in the "Miami Matches" carousel.
///
/// Solid coloured background with a subtle radial highlight, a small
/// competition badge in the corner, two team logos with "vs" between
/// them, and the match date + venue line at the bottom.
class MatchCard extends StatelessWidget {
  const MatchCard({super.key, required this.fixture});

  final MatchFixture fixture;

  @override
  Widget build(BuildContext context) {
    final base = Color(fixture.accent);
    return Container(
      width: 300.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
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
          children: [
            _topRow(),
            SizedBox(height: 14.h),
            _teamsRow(),
            const Spacer(),
            _footer(),
          ],
        ),
      ),
    );
  }

  Widget _topRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Text(
            fixture.competition,
            style: GoogleFonts.inter(
              color: Colors.black,
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
