import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/fan_profile.dart';
import 'activity_chip.dart';
import 'card_action_button.dart';
import 'sport_chip.dart';

/// Visual representation of a single profile in the Fans deck.
///
/// The widget is stateless — drag/swipe state and animation belong to
/// the parent screen. The card only knows how to render itself and
/// fan out tap callbacks.
class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.profile,
    required this.expanded,
    required this.onExpandTap,
    required this.onReplay,
    required this.onLike,
    required this.onSend,
    this.onNope,
    this.onSuperLike,
  });

  final FanProfile profile;
  final bool expanded;
  final VoidCallback onExpandTap;
  final VoidCallback onReplay;
  final VoidCallback onLike;
  final VoidCallback onSend;
  final VoidCallback? onNope;
  final VoidCallback? onSuperLike;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(40.r)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _photo(),
            _bottomGradient(),
            _boltBadge(),
            _matchBadge(),
            _contentArea(),
          ],
        ),
      ),
    );
  }

  Widget _photo() {
    return Image.network(
      profile.imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, e) => Container(
        color: Colors.orange.shade300,
        child: Icon(Icons.person, size: 100.r, color: Colors.white),
      ),
    );
  }

  Widget _bottomGradient() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 420.h,
        decoration: const BoxDecoration(
          gradient: AppColors.profileCardOverlay,
        ),
      ),
    );
  }

  Widget _boltBadge() {
    return Positioned(
      top: 20.h,
      left: 20.w,
      child: Container(
        width: 40.r,
        height: 40.r,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Image.asset(
          AppAssets.userCardBolt,
          height: 24.r,
          width: 24.r,
        ),
      ),
    );
  }

  Widget _matchBadge() {
    return Positioned(
      top: 20.h,
      right: 20.w,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.brandBadgeBg,
          borderRadius: BorderRadius.circular(50.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(AppAssets.userCardStar, height: 16.r, width: 16.r),
            SizedBox(width: 6.w),
            Text(
              '${profile.matchPercent}${AppStrings.matchSuffix}',
              style: GoogleFonts.inter(
                color: AppColors.brand,
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _contentArea() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 28.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _locationRow(),
            const SizedBox(height: 4),
            _nameRow(),
            const SizedBox(height: 4),
            _chipsAndExpander(),
            const SizedBox(height: 24),
            _actionRow(),
          ],
        ),
      ),
    );
  }

  Widget _locationRow() {
    return Row(
      children: [
        Text(profile.flag, style: TextStyle(fontSize: 16.sp)),
        SizedBox(width: 8.w),
        Text(
          profile.country,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _nameRow() {
    return Row(
      children: [
        Flexible(
          child: Text(
            '${profile.name}, ${profile.age}',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
              height: 1.2,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 4),
        if (profile.verified)
          Container(
            padding: EdgeInsets.all(2.r),
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: Image.asset(
              AppAssets.userCardVerified,
              height: 24.r,
              width: 24.r,
            ),
          ),
        if (profile.online) ...[
          const SizedBox(width: 4),
          Container(
            width: 10.r,
            height: 10.r,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ],
    );
  }

  Widget _chipsAndExpander() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: profile.sports.map((s) => SportChip(label: s)).toList(),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: profile.activities
                    .map((a) => ActivityChip(label: a))
                    .toList(),
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: onExpandTap,
          child: Container(
            width: 45.r,
            height: 45.r,
            decoration: BoxDecoration(
              color: AppColors.cardActionBg.withValues(alpha: 0.9),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white12, width: 0.5),
            ),
            child: Icon(
              expanded
                  ? Icons.keyboard_arrow_down_rounded
                  : Icons.keyboard_arrow_up_rounded,
              color: Colors.white,
              size: 32.r,
            ),
          ),
        ),
      ],
    );
  }

  Widget _actionRow() {
    return Row(
      children: expanded ? _expandedActions() : _collapsedActions(),
    );
  }

  List<Widget> _expandedActions() {
    return [
      Expanded(
        child: CardActionButton(
          iconWidget: Image.asset(
            AppAssets.userCardRefresh,
            height: 30.r,
            width: 30.r,
          ),
          color: AppColors.cardActionReplay,
          height: 68.r,
          width: double.infinity,
          onTap: onReplay,
        ),
      ),
      const SizedBox(width: 4),
      Expanded(
        child: CardActionButton(
          icon: Icons.favorite_rounded,
          color: AppColors.cardActionNope,
          height: 68.r,
          width: double.infinity,
          onTap: onNope,
        ),
      ),
      const SizedBox(width: 4),
      Expanded(
        child: CardActionButton(
          iconWidget: Image.asset(
            AppAssets.userCardLike,
            height: 30.r,
            width: 30.r,
          ),
          color: AppColors.cardActionLike,
          height: 68.r,
          width: double.infinity,
          onTap: onLike,
        ),
      ),
      const SizedBox(width: 4),
      Expanded(
        child: CardActionButton(
          icon: Icons.bolt_rounded,
          color: AppColors.cardActionSuper,
          height: 68.r,
          width: double.infinity,
          onTap: onSuperLike,
        ),
      ),
      const SizedBox(width: 4),
      Expanded(
        child: CardActionButton(
          iconWidget: Image.asset(
            AppAssets.userCardSendMessage,
            height: 30.r,
            width: 30.r,
          ),
          color: AppColors.cardActionSend,
          height: 68.r,
          width: double.infinity,
          onTap: onSend,
        ),
      ),
    ];
  }

  List<Widget> _collapsedActions() {
    return [
      Expanded(
        flex: 106,
        child: CardActionButton(
          iconWidget: Image.asset(
            AppAssets.userCardRefresh,
            height: 38.r,
            width: 38.r,
          ),
          color: AppColors.cardActionReplay,
          height: 68.r,
          width: double.infinity,
          onTap: onReplay,
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        flex: 136,
        child: CardActionButton(
          iconWidget: Image.asset(
            AppAssets.userCardLike,
            height: 40.r,
            width: 40.r,
          ),
          color: AppColors.cardActionLike,
          height: 68.r,
          width: double.infinity,
          onTap: onLike,
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        flex: 106,
        child: CardActionButton(
          iconWidget: Image.asset(
            AppAssets.userCardSendMessage,
            height: 38.r,
            width: 38.r,
          ),
          color: AppColors.cardActionSend,
          height: 68.r,
          width: double.infinity,
          onTap: onSend,
        ),
      ),
    ];
  }
}
