import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/mock_cities_data.dart';
import '../../domain/models/fan_page.dart';

/// Screen displaying all fan pages for Miami.
/// Accessible by tapping "View all" next to Miami FanPages.
class MiamiFanPagesScreen extends StatelessWidget {
  const MiamiFanPagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Generate a long list by duplicating mock pages to ensure scrollability
    final fanPages = List.generate(6, (index) => kMockFanPages[index % kMockFanPages.length]);

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
          'Miami FanPages',
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
          itemCount: fanPages.length,
          separatorBuilder: (_, index) => SizedBox(height: 16.h),
          itemBuilder: (context, index) {
            return _CustomFanPageCard(fanPage: fanPages[index]);
          },
        ),
      ),
    );
  }
}

/// Custom high-fidelity FanPage card defined locally to avoid modifying shared widgets.
class _CustomFanPageCard extends StatefulWidget {
  const _CustomFanPageCard({required this.fanPage});

  final FanPage fanPage;

  @override
  State<_CustomFanPageCard> createState() => _CustomFanPageCardState();
}

class _CustomFanPageCardState extends State<_CustomFanPageCard> {
  bool _isFollowing = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    // Format fans label to match Image 2: "54K Fans | Global Germany Supporters."
    final String rawLabel = widget.fanPage.fansLabel;
    final String cleanFansLabel;
    if (rawLabel.toLowerCase().contains('fans')) {
      cleanFansLabel = rawLabel.replaceAll(RegExp(r'fans', caseSensitive: false), 'Fans');
    } else {
      cleanFansLabel = '$rawLabel Fans';
    }
    final String combinedSubtitle = '$cleanFansLabel | ${widget.fanPage.subtitle}';

    return Container(
      height: 270.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            offset: const Offset(0, 8),
            blurRadius: 16,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              widget.fanPage.coverUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(color: AppColors.lightGrey),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0x66000000), Colors.black],
                  stops: [0.35, 0.75, 1.0],
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
                  _nameRow(),
                  SizedBox(height: 6.h),
                  Text(
                    combinedSubtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  _followButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nameRow() {
    return Row(
      children: [
        Flexible(
          child: Text(
            widget.fanPage.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
        ),
        if (widget.fanPage.verified) ...[
          SizedBox(width: 6.w),
          Icon(Icons.verified_rounded, color: Colors.white, size: 16.r),
        ],
      ],
    );
  }

  Widget _followButton() {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
          _isFollowing = !_isFollowing;
        });
      },
      onTapCancel: () => setState(() => _isPressed = false),
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          height: 44.h,
          decoration: BoxDecoration(
            color: _isFollowing
                ? Colors.white.withValues(alpha: 0.18)
                : const Color(0xFF421E21), // premium solid burgundy background
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: _isFollowing
                  ? Colors.white.withValues(alpha: 0.3)
                  : Colors.transparent,
              width: 1.w,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            _isFollowing ? 'Following' : AppStrings.follow,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
