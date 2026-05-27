import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/fan_profile.dart';
import '../providers/fans_provider.dart';
import '../widgets/fans_top_bar.dart';
import '../widgets/profile_card.dart';
import '../widgets/swipe_overlay.dart';

/// Top-level screen for the Fans tab. Hosts the swipeable deck of
/// profile cards.
///
/// Animation + drag offsets live in the State because they require a
/// `TickerProvider`. All other state (deck contents, segment, expanded
/// flag) lives in [FansProvider].
class FansScreen extends StatefulWidget {
  const FansScreen({super.key});

  @override
  State<FansScreen> createState() => _FansScreenState();
}

class _FansScreenState extends State<FansScreen>
    with TickerProviderStateMixin {
  // Drag offsets for the top (interactive) card.
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

  // ── Drag helpers ──────────────────────────────────────────────────

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
    if (_isSwiping) return;
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
      context.read<FansProvider>().popTop();
      setState(() {
        _offsetX = 0;
        _offsetY = 0;
        _isSwiping = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: const FansTopBar(),
      extendBody: true,
      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 8.h),
          child: Column(
            children: [Expanded(child: _buildCardStack())],
          ),
        ),
      ),
    );
  }

  Widget _buildCardStack() {
    final fans = context.watch<FansProvider>();
    final deck = fans.deck;

    if (deck.isEmpty) {
      return _EmptyDeck(onRefresh: () => context.read<FansProvider>().reset());
    }

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        if (deck.length > 2) _backCard(deck[2]),
        if (deck.length > 1) _middleCard(deck[1]),
        _topCard(deck[0], fans.expanded),
      ],
    );
  }

  Widget _backCard(FanProfile profile) => Positioned.fill(
        top: 12.h,
        child: Transform.scale(
          scale: 0.92,
          alignment: Alignment.bottomCenter,
          child: ProfileCard(
            profile: profile,
            expanded: false,
            onExpandTap: () {},
            onReplay: () => context.read<FansProvider>().replayLast(),
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
          child: ProfileCard(
            profile: profile,
            expanded: false,
            onExpandTap: () {},
            onReplay: () => context.read<FansProvider>().replayLast(),
            onLike: () => _doSwipe(true),
            onSend: () {},
            onNope: () => _doSwipe(false),
            onSuperLike: () {},
          ),
        ),
      );

  Widget _topCard(FanProfile profile, bool expanded) {
    final fans = context.read<FansProvider>();
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
                ProfileCard(
                  profile: profile,
                  expanded: expanded,
                  onExpandTap: fans.toggleExpanded,
                  onReplay: fans.replayLast,
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
