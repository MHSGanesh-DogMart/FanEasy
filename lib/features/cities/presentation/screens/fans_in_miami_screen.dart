import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../fans/domain/models/fan_profile.dart';
import '../../../fans/presentation/widgets/swipe_overlay.dart';

/// Screen displaying swipeable cards for fans in Miami.
/// Accessible by tapping "View all" next to Miami Fans.
/// Confined and isolated locally inside this screen to keep the main Fans flow untouched.
class FansInMiamiScreen extends StatefulWidget {
  const FansInMiamiScreen({super.key});

  @override
  State<FansInMiamiScreen> createState() => _FansInMiamiScreenState();
}

class _FansInMiamiScreenState extends State<FansInMiamiScreen>
    with TickerProviderStateMixin {
  
  // Localized swipe deck state
  late List<FanProfile> _deck;
  final List<FanProfile> _history = [];

  double _offsetX = 0;
  double _offsetY = 0;
  bool _isDragging = false;
  bool _isSwiping = false;

  late final AnimationController _snapCtrl;
  late Animation<double> _snapX;
  late Animation<double> _snapY;

  late final AnimationController _swipeCtrl;
  late Animation<double> _swipeX;
  late Animation<double> _swipeY;

  @override
  void initState() {
    super.initState();
    
    // Initialize our localized swipe deck with Maira, 24 at the top
    _deck = [
      const FanProfile(
        name: 'Maira',
        age: 24,
        country: 'USA',
        flag: '🇺🇸',
        sports: ['✈️ Wimbledon', '🎾 Federer'],
        activities: ['🏟️ Watch Parties', '🎤 Concerts'],
        matchPercent: 95,
        imageUrl: 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=900',
        verified: true,
        online: true,
      ),
      const FanProfile(
        name: 'Hudson',
        age: 27,
        country: 'USA',
        flag: '🇺🇸',
        sports: ['⚽ FIFA 2026', '🏈 NFL'],
        activities: ['Watch Parties', 'Concerts'],
        matchPercent: 95,
        imageUrl: 'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=800&auto=format',
        verified: true,
        online: true,
      ),
      const FanProfile(
        name: 'Marcus',
        age: 29,
        country: 'UK',
        flag: '🇬🇧',
        sports: ['⚽ Premier League', '🏉 Rugby'],
        activities: ['Live Games', 'Sports Bars'],
        matchPercent: 88,
        imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800&auto=format',
        verified: true,
        online: false,
      ),
      const FanProfile(
        name: 'Jaylen',
        age: 24,
        country: 'USA',
        flag: '🇺🇸',
        sports: ['🏀 NBA', '⚾ MLB'],
        activities: ['Watch Parties', 'Tailgates'],
        matchPercent: 91,
        imageUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=800&auto=format',
        verified: false,
        online: true,
      ),
    ];

    _snapCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    )..addListener(() => setState(() {}));

    _swipeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _snapCtrl.dispose();
    _swipeCtrl.dispose();
    super.dispose();
  }

  double get _cardX {
    if (_isDragging) return _offsetX;
    if (_isSwiping && _swipeCtrl.isAnimating) return _swipeX.value;
    if (_snapCtrl.isAnimating) return _snapX.value;
    return 0;
  }

  double get _cardY {
    if (_isDragging) return _offsetY;
    if (_isSwiping && _swipeCtrl.isAnimating) return _swipeY.value;
    if (_snapCtrl.isAnimating) return _snapY.value;
    return 0;
  }

  void _snapBack() {
    _snapX = Tween<double>(begin: _offsetX, end: 0)
        .animate(CurvedAnimation(parent: _snapCtrl, curve: Curves.elasticOut));
    _snapY = Tween<double>(begin: _offsetY, end: 0)
        .animate(CurvedAnimation(parent: _snapCtrl, curve: Curves.elasticOut));
    _isDragging = false;
    _snapCtrl.reset();
    _snapCtrl.forward().whenComplete(() {
      setState(() {
        _offsetX = 0;
        _offsetY = 0;
      });
    });
  }

  void _doSwipe(bool liked) {
    if (_isSwiping || _deck.isEmpty) return;
    final targetX =
        liked ? AppDimensions.swipeOffscreenX : -AppDimensions.swipeOffscreenX;
    _swipeX = Tween<double>(begin: _offsetX, end: targetX)
        .animate(CurvedAnimation(parent: _swipeCtrl, curve: Curves.easeIn));
    _swipeY = Tween<double>(begin: _offsetY, end: _offsetY + 80)
        .animate(CurvedAnimation(parent: _swipeCtrl, curve: Curves.easeIn));
    _isDragging = false;
    _isSwiping = true;
    _swipeCtrl.reset();
    _swipeCtrl.forward().whenComplete(() {
      setState(() {
        final popped = _deck.removeAt(0);
        _history.add(popped);
        _offsetX = 0;
        _offsetY = 0;
        _isSwiping = false;
      });
    });
  }

  void _doRewind() {
    if (_isSwiping || _history.isEmpty) return;
    setState(() {
      final restored = _history.removeLast();
      _deck.insert(0, restored);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAF9F6),
      appBar: AppBar(
        backgroundColor: const Color(0xffFAF9F6),
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Fans in Miami',
          style: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w, top: 6.h, bottom: 6.h),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 44.r,
                height: 44.r,
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
                  Icons.close_rounded,
                  color: Colors.black,
                  size: 24.r,
                ),
              ),
            ),
          ),
        ],
      ),
      extendBody: true,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 8.h, bottom: 20.h),
          child: Column(
            children: [Expanded(child: _buildCardStack())],
          ),
        ),
      ),
    );
  }

  Widget _buildCardStack() {
    if (_deck.isEmpty) {
      return _EmptyDeck(onRefresh: () {
        setState(() {
          _history.clear();
          _deck = [
            const FanProfile(
              name: 'Maira',
              age: 24,
              country: 'USA',
              flag: '🇺🇸',
              sports: ['✈️ Wimbledon', '🎾 Federer'],
              activities: ['🏟️ Watch Parties', '🎤 Concerts'],
              matchPercent: 95,
              imageUrl: 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=900',
              verified: true,
              online: true,
            ),
            const FanProfile(
              name: 'Hudson',
              age: 27,
              country: 'USA',
              flag: '🇺🇸',
              sports: ['⚽ FIFA 2026', '🏈 NFL'],
              activities: ['Watch Parties', 'Concerts'],
              matchPercent: 95,
              imageUrl: 'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=800&auto=format',
              verified: true,
              online: true,
            ),
            const FanProfile(
              name: 'Marcus',
              age: 29,
              country: 'UK',
              flag: '🇬🇧',
              sports: ['⚽ Premier League', '🏉 Rugby'],
              activities: ['Live Games', 'Sports Bars'],
              matchPercent: 88,
              imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800&auto=format',
              verified: true,
              online: false,
            ),
            const FanProfile(
              name: 'Jaylen',
              age: 24,
              country: 'USA',
              flag: '🇺🇸',
              sports: ['🏀 NBA', '⚾ MLB'],
              activities: ['Watch Parties', 'Tailgates'],
              matchPercent: 91,
              imageUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=800&auto=format',
              verified: false,
              online: true,
            ),
          ];
        });
      });
    }

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        if (_deck.length > 2) _backCard(_deck[2]),
        if (_deck.length > 1) _middleCard(_deck[1]),
        _topCard(_deck[0]),
      ],
    );
  }

  Widget _backCard(FanProfile profile) => Positioned.fill(
        top: 12.h,
        child: Transform.scale(
          scale: 0.92,
          alignment: Alignment.bottomCenter,
          child: _CustomSwipeProfileCard(
            profile: profile,
            onReplay: _doRewind,
            onLike: () => _doSwipe(true),
            onSend: () {},
            onNope: () => _doSwipe(false),
            onSuperLike: () {},
          ),
        ),
      );

  Widget _middleCard(FanProfile profile) => Positioned.fill(
        top: 6.h,
        child: Transform.scale(
          scale: 0.96,
          alignment: Alignment.bottomCenter,
          child: _CustomSwipeProfileCard(
            profile: profile,
            onReplay: _doRewind,
            onLike: () => _doSwipe(true),
            onSend: () {},
            onNope: () => _doSwipe(false),
            onSuperLike: () {},
          ),
        ),
      );

  Widget _topCard(FanProfile profile) {
    return Positioned.fill(
      child: GestureDetector(
        onPanStart: (_) {
          if (_isSwiping) return;
          setState(() => _isDragging = true);
        },
        onPanUpdate: (d) {
          if (_isSwiping) return;
          setState(() {
            _offsetX += d.delta.dx;
            _offsetY += d.delta.dy;
          });
        },
        onPanEnd: (_) {
          if (_isSwiping) return;
          if (_offsetX.abs() > AppDimensions.swipeThreshold) {
            _doSwipe(_offsetX > 0);
          } else {
            _snapBack();
          }
        },
        child: Transform.translate(
          offset: Offset(_cardX, _cardY),
          child: Transform.rotate(
            angle: _cardX / 22 * (math.pi / 180) * 5,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _CustomSwipeProfileCard(
                  profile: profile,
                  onReplay: _doRewind,
                  onLike: () => _doSwipe(true),
                  onSend: () {},
                  onNope: () => _doSwipe(false),
                  onSuperLike: () {},
                ),
                if (_cardX > 15)
                  SwipeOverlay(
                    label: AppStrings.overlayLike,
                    color: AppColors.success,
                    opacity: (_cardX / 180).clamp(0.0, 1.0),
                    alignment: Alignment.topLeft,
                  ),
                if (_cardX < -15)
                  SwipeOverlay(
                    label: AppStrings.overlayNope,
                    color: AppColors.error,
                    opacity: (_cardX.abs() / 180).clamp(0.0, 1.0),
                    alignment: Alignment.topRight,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Frosted-glass dark pill used to surface a profile's sport interest locally.
class _CustomSportChip extends StatelessWidget {
  const _CustomSportChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(100.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
          width: 0.8.w,
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.1,
        ),
      ),
    );
  }
}

/// Frosted-glass dark pill used for activity tags locally.
class _CustomActivityChip extends StatelessWidget {
  const _CustomActivityChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(100.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
          width: 0.8.w,
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.1,
        ),
      ),
    );
  }
}

/// High-fidelity local Swipe Profile Card that replicates Image 3 completely.
class _CustomSwipeProfileCard extends StatelessWidget {
  const _CustomSwipeProfileCard({
    required this.profile,
    required this.onReplay,
    required this.onLike,
    required this.onSend,
    required this.onNope,
    required this.onSuperLike,
  });

  final FanProfile profile;
  final VoidCallback onReplay;
  final VoidCallback onLike;
  final VoidCallback onSend;
  final VoidCallback onNope;
  final VoidCallback onSuperLike;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            offset: const Offset(0, 10),
            blurRadius: 24,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _photo(),
            _bottomGradient(),
            _rewindBadge(),
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

  Widget _rewindBadge() {
    return Positioned(
      top: 20.h,
      left: 20.w,
      child: GestureDetector(
        onTap: onReplay,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 44.r,
          height: 44.r,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.4),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1.w,
            ),
          ),
          child: Icon(
            Icons.replay_rounded,
            color: Colors.white,
            size: 24.r,
          ),
        ),
      ),
    );
  }

  Widget _matchBadge() {
    return Positioned(
      top: 20.h,
      right: 20.w,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: const Color(0xFFE13353),
          borderRadius: BorderRadius.circular(50.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.favorite_rounded,
              color: Colors.white,
              size: 13.r,
            ),
            SizedBox(width: 4.w),
            Text(
              '${profile.matchPercent}% Match',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w700,
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
        padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _locationRow(),
            SizedBox(height: 6.h),
            _nameRow(),
            SizedBox(height: 12.h),
            _chipsRow(),
            SizedBox(height: 24.h),
            _actionRow(),
            SizedBox(height: 16.h),
            _pageDotsIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _locationRow() {
    return Row(
      children: [
        Text(profile.flag, style: TextStyle(fontSize: 16.sp)),
        SizedBox(width: 6.w),
        Text(
          profile.country.toUpperCase(),
          style: GoogleFonts.inter(
            color: Colors.white.withValues(alpha: 0.85),
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
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
              fontSize: 26.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
              height: 1.2,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 6),
        if (profile.verified)
          Icon(
            Icons.verified_rounded,
            color: Colors.white,
            size: 20.r,
          ),
        if (profile.online) ...[
          const SizedBox(width: 6),
          Container(
            width: 8.r,
            height: 8.r,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ],
    );
  }

  Widget _chipsRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: profile.sports.map((s) => _CustomSportChip(label: s)).toList(),
        ),
        if (profile.sports.isNotEmpty && profile.activities.isNotEmpty)
          SizedBox(height: 8.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: profile.activities.map((a) => _CustomActivityChip(label: a)).toList(),
        ),
      ],
    );
  }

  Widget _actionRow() {
    return Row(
      children: [
        const Spacer(),
        _circleActionButton(
          icon: Icons.close_rounded,
          color: const Color(0xFFEF4444),
          onTap: onNope,
        ),
        SizedBox(width: 14.w),
        _circleActionButton(
          icon: Icons.star_rounded,
          color: const Color(0xFFFFB000),
          onTap: onSuperLike,
        ),
        SizedBox(width: 14.w),
        _circleActionButton(
          icon: Icons.near_me_rounded,
          color: const Color(0xFF22C55E),
          onTap: onSend,
        ),
        SizedBox(width: 14.w),
        _circleActionButton(
          icon: Icons.favorite_rounded,
          color: const Color(0xFFE13353),
          onTap: onLike,
        ),
        const Spacer(),
      ],
    );
  }

  Widget _circleActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 60.r,
        height: 60.r,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.45),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.15),
            width: 1.w,
          ),
        ),
        child: Center(
          child: Icon(
            icon,
            color: color,
            size: 26.r,
          ),
        ),
      ),
    );
  }

  Widget _pageDotsIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final isActive = index == 0;
        return Container(
          width: 6.r,
          height: 6.r,
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.35),
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}

class _EmptyDeck extends StatelessWidget {
  const _EmptyDeck({required this.onRefresh});

  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.people_outline_rounded,
            size: 72.r,
            color: Colors.grey.shade300,
          ),
          SizedBox(height: 16.h),
          Text(
            AppStrings.seenEveryone,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 16.sp),
          ),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: onRefresh,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColors.brand,
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Text(
                AppStrings.refresh,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
