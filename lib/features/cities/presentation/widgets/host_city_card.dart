import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/mock_cities_data.dart';
import '../../domain/models/host_city.dart';
import '../providers/cities_provider.dart';

/// Big rounded card showing a host-city cover photo, the city name with
/// a country flag, "Host City" subtitle, and three stats at the bottom.
///
/// Features a fully interactive frosted glassmorphism dropdown overlay
/// to choose other host cities and navigate between them.
class HostCityCard extends StatefulWidget {
  const HostCityCard({super.key, required this.city});

  final HostCity city;

  @override
  State<HostCityCard> createState() => _HostCityCardState();
}

class _HostCityCardState extends State<HostCityCard> {
  bool _isDropdownOpen = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.r),
        // color: Color(0xffffffff),
        border: Border.all(color: Colors.white, width: 2.5.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            offset: Offset(0, 12.h),
            blurRadius: 26.r,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: Offset(0, 47.h),
            blurRadius: 47.r,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            offset: Offset(0, 106.h),
            blurRadius: 64.r,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            offset: Offset(0, 189.h),
            blurRadius: 76.r,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.00),
            offset: Offset(0, 296.h),
            blurRadius: 83.r,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25.5.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              widget.city.coverUrl,
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
                    Color(0x33000000),
                    Color(0xBB000000),
                  ],
                  stops: [0.3, 0.6, 1.0],
                ),
              ),
            ),
            Positioned(
              left: 16.w,
              right: 16.w,
              bottom: 16.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _flagPill(),
                  SizedBox(height: 8.h),
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
                  SizedBox(height: 14.h),
                  _statsRow(),
                ],
              ),
            ),
            if (_isDropdownOpen) _buildDropdownOverlay(),
          ],
        ),
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
          Text(widget.city.flag, style: TextStyle(fontSize: 12.sp)),
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
    return GestureDetector(
      onTap: () {
        setState(() {
          _isDropdownOpen = !_isDropdownOpen;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.city.name,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 26.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
              height: 1.1,
            ),
          ),
          SizedBox(width: 4.w),
          Icon(
            _isDropdownOpen
                ? Icons.keyboard_arrow_up_rounded
                : Icons.keyboard_arrow_down_rounded,
            color: Colors.white,
            size: 24.r,
          ),
        ],
      ),
    );
  }

  Widget _statsRow() {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            widget.city.fansVisiting,
            AppStrings.statFansVisiting,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _statCard('${widget.city.fanPages}', AppStrings.statFanPages),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _statCard('${widget.city.matches}', AppStrings.statMatches),
        ),
      ],
    );
  }

  Widget _statCard(String value, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.24),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.3,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownOverlay() {
    return Positioned(
      top: 16.h,
      right: 16.w,
      width: 190.w,
      height: 230.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.12),
                width: 1.w,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(kMockHostCities.length, (index) {
                final c = kMockHostCities[index];
                final isCurrent = c.name == widget.city.name;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isDropdownOpen = false;
                        });
                        context.read<CitiesProvider>().selectCity(index);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 4.h,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                c.name,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: isCurrent
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
                            ),
                            if (isCurrent)
                              Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 16.r,
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (index < kMockHostCities.length - 1)
                      Divider(
                        color: Colors.white.withValues(alpha: 0.12),
                        height: 1,
                        thickness: 0.5,
                        indent: 16.w,
                        endIndent: 16.w,
                      ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
