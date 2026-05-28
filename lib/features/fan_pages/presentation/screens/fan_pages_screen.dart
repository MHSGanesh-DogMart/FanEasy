import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/router/app_routes.dart';
import '../../../cities/presentation/widgets/league_filter_row.dart';
import '../../../cities/presentation/widgets/section_header.dart';
import '../../../cities/presentation/widgets/sport_filter_row.dart';

/// Highly polished, interactive Fan Pages explorer screen tab.
/// Replicates the structural UI of CitiesScreen (lazy loading, shared sport and league
/// filters) with customized horizontal lists for Following, Trending, and Popular sections.
class FanPagesScreen extends StatelessWidget {
  const FanPagesScreen({super.key});

  // Mock data for the "Following" section
  static const List<Map<String, String>> _followingPages = [
    {
      'name': 'Seattle Seahawks',
      'fans': '4.2K Fans',
      'image':
          'https://images.unsplash.com/photo-1566577739112-5180d4bf9390?w=600',
    },
    {
      'name': 'New York Jets',
      'fans': '4.2K Fans',
      'image':
          'https://images.unsplash.com/photo-1612872087720-bb876e2e67d1?w=600',
    },
    {
      'name': 'San Francisco 49ers',
      'fans': '5.1K Fans',
      'image':
          'https://images.unsplash.com/photo-1587280501635-68a0e82cd5ff?w=600',
    },
  ];

  // Mock data for the "Trending" section
  static const List<Map<String, dynamic>> _trendingPages = [
    {
      'name': 'Germany Fans Page',
      'subtitle': 'Global Germany Supporters.',
      'fans': '54K fans',
      'verified': true,
      'image':
          'https://images.unsplash.com/photo-1517649763962-0c623066013b?w=800',
    },
    {
      'name': 'Brazil Fans Page',
      'subtitle': 'Global Brazil Supporters.',
      'fans': '76K fans',
      'verified': true,
      'image':
          'https://images.unsplash.com/photo-1489945052260-4f21c52268b9?w=800',
    },
    {
      'name': 'France Fans Page',
      'subtitle': 'Allez Les Bleus Supporters.',
      'fans': '62K fans',
      'verified': true,
      'image':
          'https://images.unsplash.com/photo-1509062522246-3755977927d7?w=800',
    },
  ];

  // Mock data for the "Popular" section (scrolled continuation mockups)
  static const List<Map<String, String>> _popularPages = [
    {
      'name': 'Cleveland Browns',
      'fans': '4.2K Fans',
      'image':
          'https://images.unsplash.com/photo-1508098682722-e99c43a406b2?w=600',
    },
    {
      'name': 'Miami Dolphins',
      'fans': '4.2K Fans',
      'image':
          'https://images.unsplash.com/photo-1612872087720-bb876e2e67d1?w=600',
    },
    {
      'name': 'Buffalo Bills',
      'fans': '3.9K Fans',
      'image':
          'https://images.unsplash.com/photo-1566577739112-5180d4bf9390?w=600',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Elegant clearance gap to completely clear the floating bottom navigation bar
    final bottomGap = MediaQuery.of(context).padding.bottom + 20.h;

    final sections = <Widget Function()>[
      () => const SportFilterRow(),
      () => SizedBox(height: 12.h),
      () => const LeagueFilterRow(),
      () => SizedBox(height: 20.h),
      () => SectionHeader(
        title: 'Following',
        onViewAll: () => Navigator.pushNamed(context, AppRoutes.miamiFanPages),
      ),
      () => SizedBox(height: 12.h),
      _followingList,
      () => SizedBox(height: 24.h),
      () => SectionHeader(
        title: 'Trending',
        onViewAll: () => Navigator.pushNamed(context, AppRoutes.miamiFanPages),
      ),
      () => SizedBox(height: 12.h),
      _trendingList,
      () => SizedBox(height: 24.h),
      () => SectionHeader(
        title: 'Popular',
        onViewAll: () => Navigator.pushNamed(context, AppRoutes.miamiFanPages),
      ),
      () => SizedBox(height: 12.h),
      _popularList,
    ];

    return Scaffold(
      backgroundColor: const Color(0xffFAF9F6),
      appBar: const FanPagesAppBar(),
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

  Widget _followingList() {
    return SizedBox(
      height: 172.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: _followingPages.length,
        itemBuilder: (context, index) {
          final team = _followingPages[index];
          return Padding(
            padding: EdgeInsets.only(
              right: index < _followingPages.length - 1 ? 12.w : 0,
            ),
            child: GestureDetector(
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.fanPageDetail),
              child: Container(
                width: 196.w,
                height: 154.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24.r),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        team['image']!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(color: Colors.grey.shade400),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 76.h,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(24.r),
                            bottomRight: Radius.circular(24.r),
                          ),
                          child: ShaderMask(
                            shaderCallback: (rect) {
                              return const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Colors.black],
                                stops: [0.0, 1.0],
                              ).createShader(rect);
                            },
                            blendMode: BlendMode.dstIn,
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withValues(alpha: 0.5),
                                    ],
                                    stops: const [0.0, 1.0],
                                  ),
                                ),
                              ),
                            ),
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
                            Text(
                              team['name']!,
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.3,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.group_rounded,
                                  color: Colors.white.withValues(alpha: 0.85),
                                  size: 13.r,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  team['fans']!,
                                  style: GoogleFonts.inter(
                                    color: Colors.white.withValues(alpha: 0.85),
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _trendingList() {
    return SizedBox(
      height: 270.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: _trendingPages.length,
        itemBuilder: (context, index) {
          final page = _trendingPages[index];
          return Padding(
            padding: EdgeInsets.only(
              right: index < _trendingPages.length - 1 ? 12.w : 0,
            ),
            child: _TrendingPageCard(page: page),
          );
        },
      ),
    );
  }

  Widget _popularList() {
    return SizedBox(
      height: 192.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: _popularPages.length,
        itemBuilder: (context, index) {
          final page = _popularPages[index];
          return Padding(
            padding: EdgeInsets.only(
              right: index < _popularPages.length - 1 ? 12.w : 0,
            ),
            child: _PopularPageCard(page: page),
          );
        },
      ),
    );
  }
}

/// Custom high-fidelity stateful card for Trending pages.
/// Replicates the premium card design from Cities (Miami Fanpages card).
class _TrendingPageCard extends StatefulWidget {
  const _TrendingPageCard({required this.page});

  final Map<String, dynamic> page;

  @override
  State<_TrendingPageCard> createState() => _TrendingPageCardState();
}

class _TrendingPageCardState extends State<_TrendingPageCard> {
  bool _isFollowing = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.fanPageDetail),
      child: Container(
        width: 280.w,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(24.r)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                widget.page['image']!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(color: Colors.grey.shade400),
              ),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Color(0x99000000),
                      Colors.black,
                    ],
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
                    _fansPill(),
                    SizedBox(height: 8.h),
                    _nameRow(),
                    SizedBox(height: 4.h),
                    Text(
                      widget.page['subtitle']!,
                      style: GoogleFonts.inter(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _buildFollowButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fansPill() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.group_rounded, color: Colors.white, size: 12.r),
          SizedBox(width: 6.w),
          Text(
            widget.page['fans']!,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _nameRow() {
    return Row(
      children: [
        Flexible(
          child: Text(
            widget.page['name']!,
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
        if (widget.page['verified'] == true) ...[
          SizedBox(width: 6.w),
          Icon(Icons.verified_rounded, color: Colors.white, size: 16.r),
        ],
      ],
    );
  }

  Widget _buildFollowButton() {
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
          height: 38.h,
          decoration: BoxDecoration(
            color: _isFollowing
                ? Colors.white.withValues(alpha: 0.55)
                : Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: _isFollowing
                  ? Colors.white.withValues(alpha: 0.78)
                  : Colors.white.withValues(alpha: 0.24),
              width: 1.w,
            ),
          ),
          alignment: Alignment.center,
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            style: GoogleFonts.inter(
              color: _isFollowing ? const Color(0xFF1C1C1E) : Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
            child: Text(
              _isFollowing ? 'Following' : 'Follow',
              style: TextStyle(
                color: _isFollowing ? const Color(0xFF1C1C1E) : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom high-fidelity stateful card for Popular pages.
/// Leverages dynamic Follow/Following states with interactive animations.
class _PopularPageCard extends StatefulWidget {
  const _PopularPageCard({required this.page});

  final Map<String, String> page;

  @override
  State<_PopularPageCard> createState() => _PopularPageCardState();
}

class _PopularPageCardState extends State<_PopularPageCard> {
  bool _isFollowing = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.fanPageDetail),
      child: Container(
        width: 256.w,
        height: 176.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                widget.page['image']!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(color: Colors.grey.shade400),
              ),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Color(0x99000000),
                      Colors.black,
                    ],
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
                    Text(
                      widget.page['name']!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.group_rounded,
                          color: Colors.white.withValues(alpha: 0.85),
                          size: 13.r,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          widget.page['fans']!,
                          style: GoogleFonts.inter(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    _buildFollowButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFollowButton() {
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
          height: 38.h,
          decoration: BoxDecoration(
            color: _isFollowing
                ? Colors.white.withValues(alpha: 0.55)
                : Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: _isFollowing
                  ? Colors.white.withValues(alpha: 0.78)
                  : Colors.white.withValues(alpha: 0.24),
              width: 1.w,
            ),
          ),
          alignment: Alignment.center,
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            style: GoogleFonts.inter(
              color: _isFollowing ? const Color(0xFF1C1C1E) : Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
            child: Text(
              _isFollowing ? 'Following' : 'Follow',
              style: TextStyle(
                color: _isFollowing ? const Color(0xFF1C1C1E) : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FanPagesAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FanPagesAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xffFAF9F6),
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 56.h,
      titleSpacing: 0,
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: [
            Text(
              'Fan Pages',
              style: GoogleFonts.inter(
                color: Colors.black,
                fontSize: 26.sp,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.8,
              ),
            ),
          ],
        ),
      ),
      actions: [
        Row(
          children: [
            _avatar(),
            SizedBox(width: 20.w),
          ],
        ),
      ],
    );
  }

  Widget _avatar() {
    return Container(
      width: 42.r,
      height: 42.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2.w),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: ClipOval(
        child: Image.network(
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&auto=format',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
