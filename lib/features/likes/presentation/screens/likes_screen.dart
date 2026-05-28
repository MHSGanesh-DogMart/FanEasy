import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../features/main_navigation/presentation/providers/bottom_nav_provider.dart';

/// Highly polished, interactive Likes Screen tab.
/// Matches all "Received", "Sent", "Favorites", and "Matched" sub-filter mockups with pixel-perfect accuracy.
class LikesScreen extends StatefulWidget {
  const LikesScreen({super.key});

  @override
  State<LikesScreen> createState() => _LikesScreenState();
}

class _LikesScreenState extends State<LikesScreen> {
  String _activeFilter = 'Received';

  // Sub-filter tabs
  final List<String> _filters = ['Received', 'Sent', 'Favorites', 'Matched'];

  // Mock profiles for the "Received" tab (Nope & Green Like actions, no chips)
  final List<_MockLikeProfile> _receivedProfiles = [
    _MockLikeProfile(
      name: 'Hudson, 27',
      flag: '🇺🇸',
      country: 'USA',
      imageUrl:
          'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=800',
    ),
    _MockLikeProfile(
      name: 'Emily, 22',
      flag: '🇺🇸',
      country: 'USA',
      imageUrl:
          'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=800',
    ),
    _MockLikeProfile(
      name: 'John Smith, 35',
      flag: '🇺🇸',
      country: 'USA',
      imageUrl:
          'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=800',
    ),
    _MockLikeProfile(
      name: 'John Smith, 35',
      flag: '🇺🇸',
      country: 'USA',
      imageUrl:
          'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=800',
    ),
    _MockLikeProfile(
      name: 'Carlos, 31',
      flag: '🇧🇷',
      country: 'Brazil',
      imageUrl:
          'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=800',
    ),
    _MockLikeProfile(
      name: 'Marcus, 29',
      flag: '🇬🇧',
      country: 'UK',
      imageUrl:
          'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=800',
    ),
  ];

  // Mock profiles for the "Sent" tab (Hudson, 27 with interests & Star/Send actions)
  final List<_MockLikeProfile> _sentProfiles = List.generate(
    6,
    (index) => _MockLikeProfile(
      name: 'Hudson, 27',
      flag: '🇺🇸',
      country: 'USA',
      imageUrl:
          'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=800',
      sports: ['✈️ Wimbledon', '🎾 Federer'],
      activities: ['🏟️ Watch Parties', '🎤 Concerts'],
    ),
  );

  // Mock profiles for the "Favorites" tab (Maira & Hudson with top-right star, interests & Pink Like/Send actions)
  final List<_MockLikeProfile> _favoritesProfiles = [
    _MockLikeProfile(
      name: 'Maira, 24',
      flag: '🇺🇸',
      country: 'USA',
      imageUrl:
          'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=800',
      sports: ['✈️ Wimbledon', '🎾 Federer'],
      activities: ['🏟️ Watch Parties', '🎤 Concerts'],
    ),
    _MockLikeProfile(
      name: 'Hudson, 27',
      flag: '🇺🇸',
      country: 'USA',
      imageUrl:
          'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=800',
      sports: ['✈️ Wimbledon', '🎾 Federer'],
      activities: ['🏟️ Watch Parties', '🎤 Concerts'],
    ),
    _MockLikeProfile(
      name: 'Carlos, 31',
      flag: '🇧🇷',
      country: 'Brazil',
      imageUrl:
          'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=800',
      sports: ['⚽ Copa America', '🏎️ F1', '🏆 World Cup'],
      activities: ['Watch Parties', 'Fan Zones'],
    ),
    _MockLikeProfile(
      name: 'Marcus, 29',
      flag: '🇬🇧',
      country: 'UK',
      imageUrl:
          'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=800',
      sports: ['⚽ Premier League', '🏉 Rugby'],
      activities: ['Live Games', 'Sports Bars'],
    ),
    _MockLikeProfile(
      name: 'Hudson, 27',
      flag: '🇺🇸',
      country: 'USA',
      imageUrl:
          'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=800',
      sports: ['✈️ Wimbledon', '🎾 Federer'],
      activities: ['🏟️ Watch Parties', '🎤 Concerts'],
    ),
    _MockLikeProfile(
      name: 'Hudson, 27',
      flag: '🇺🇸',
      country: 'USA',
      imageUrl:
          'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=800',
      sports: ['✈️ Wimbledon', '🎾 Federer'],
      activities: ['🏟️ Watch Parties', '🎤 Concerts'],
    ),
  ];

  // Mock profiles for the "Matched" tab (Hudson, 27 with interests & top-right more vert, Star/Send actions)
  final List<_MockLikeProfile> _matchedProfiles = List.generate(
    6,
    (index) => _MockLikeProfile(
      name: 'Hudson, 27',
      flag: '🇺🇸',
      country: 'USA',
      imageUrl:
          'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=800',
      sports: ['✈️ Wimbledon', '🎾 Federer'],
      activities: ['🏟️ Watch Parties', '🎤 Concerts'],
    ),
  );

  @override
  Widget build(BuildContext context) {
    // Bottom safety spacing to clear the floating bottom navigation bar
    final bottomPadding = MediaQuery.of(context).padding.bottom + 90.h;

    // Select profiles based on active tab selection
    final List<_MockLikeProfile> currentProfiles;
    if (_activeFilter == 'Sent') {
      currentProfiles = _sentProfiles;
    } else if (_activeFilter == 'Favorites') {
      currentProfiles = _favoritesProfiles;
    } else if (_activeFilter == 'Matched') {
      currentProfiles = _matchedProfiles;
    } else {
      currentProfiles = _receivedProfiles;
    }

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
            onTap: () {
              context.read<BottomNavProvider>().setIndex(0);
            },
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
          'Likes',
          style: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SizedBox(height: 8.h),
            _subFilterSelector(),
            SizedBox(height: 16.h),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  top: 4.h,
                  bottom: bottomPadding,
                ),
                itemCount: currentProfiles.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 150 / 220,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                ),
                itemBuilder: (context, index) {
                  return _LikeGridTile(
                    profile: currentProfiles[index],
                    activeFilter: _activeFilter,
                    onNope: () {
                      setState(() {
                        currentProfiles.removeAt(index);
                      });
                    },
                    onLike: () {
                      setState(() {
                        currentProfiles.removeAt(index);
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _subFilterSelector() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        height: 48.h,
        padding: EdgeInsets.all(4.r),
        decoration: BoxDecoration(
          color: const Color(0xffF2F2ED),
          borderRadius: BorderRadius.circular(100.r),
        ),
        child: Row(
          children: _filters.map((filter) {
            final isSelected = _activeFilter == filter;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _activeFilter = filter),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(100.r),
                    boxShadow: isSelected
                        ? const [
                            BoxShadow(
                              color: Color(0x0F000000),
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    filter,
                    style: GoogleFonts.inter(
                      color: isSelected
                          ? AppColors.brand
                          : const Color(0xff777777),
                      fontSize: 13.sp,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// Helper data class for local Likes mock data.
class _MockLikeProfile {
  _MockLikeProfile({
    required this.name,
    required this.flag,
    required this.country,
    required this.imageUrl,
    this.sports = const [],
    this.activities = const [],
  });

  final String name;
  final String flag;
  final String country;
  final String imageUrl;
  final List<String> sports;
  final List<String> activities;
}

/// Helper card widget that renders profiles inside the grid.
class _LikeGridTile extends StatelessWidget {
  const _LikeGridTile({
    required this.profile,
    required this.onNope,
    required this.onLike,
    required this.activeFilter,
  });

  final _MockLikeProfile profile;
  final VoidCallback onNope;
  final VoidCallback onLike;
  final String activeFilter;

  @override
  Widget build(BuildContext context) {
    final isSent = activeFilter == 'Sent';
    final isFavorites = activeFilter == 'Favorites';
    final isMatched = activeFilter == 'Matched';
    final showChips = isSent || isFavorites || isMatched;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            offset: const Offset(0, 6),
            blurRadius: 12,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              profile.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(color: AppColors.lightGrey),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0x66000000), Colors.black],
                  stops: [0.4, 0.75, 1.0],
                ),
              ),
            ),
            if (isFavorites) _favoritesStarBadge(),
            if (isMatched) _matchedMoreButton(),
            Positioned(
              left: 12.w,
              right: 12.w,
              bottom: 12.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _locationRow(),
                  SizedBox(height: 4.h),
                  Text(
                    profile.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                  if (showChips) ...[SizedBox(height: 8.h), _chipsRow()],
                  SizedBox(height: 10.h),
                  _actionsRow(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _favoritesStarBadge() {
    return Positioned(
      top: 12.h,
      right: 12.w,
      child: Container(
        width: 24.r,
        height: 24.r,
        decoration: const BoxDecoration(
          color: Color(0xFFFFB000), // premium gold star background
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.star_rounded, color: Colors.white, size: 14.r),
      ),
    );
  }

  Widget _matchedMoreButton() {
    return Positioned(
      top: 12.h,
      right: 12.w,
      child: Container(
        width: 32.r,
        height: 32.r,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.35),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.more_vert_rounded, color: Colors.white, size: 18.r),
      ),
    );
  }

  Widget _locationRow() {
    return Row(
      children: [
        Text(profile.flag, style: TextStyle(fontSize: 14.sp)),
        SizedBox(width: 4.w),
        Text(
          profile.country.toUpperCase(),
          style: GoogleFonts.inter(
            color: Colors.white.withValues(alpha: 0.85),
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _chipsRow() {
    final allInterests = [...profile.sports, ...profile.activities];
    if (allInterests.isEmpty) return const SizedBox.shrink();

    final List<String> displayed;
    final bool hasMore;
    final int moreCount;

    if (allInterests.length <= 4) {
      displayed = allInterests;
      hasMore = false;
      moreCount = 0;
    } else {
      displayed = allInterests.sublist(0, 3);
      hasMore = true;
      moreCount = allInterests.length - 3;
    }

    final List<Widget> rows = [];

    // Row 1
    if (displayed.isNotEmpty) {
      final List<Widget> row1Children = [];
      row1Children.add(Expanded(child: _CustomMiniChip(label: displayed[0])));
      row1Children.add(SizedBox(width: 4.w));
      if (displayed.length > 1) {
        row1Children.add(Expanded(child: _CustomMiniChip(label: displayed[1])));
      } else {
        row1Children.add(const Expanded(child: SizedBox.shrink()));
      }
      rows.add(Row(children: row1Children));
    }

    // Row 2
    if (displayed.length > 2 || hasMore) {
      final List<Widget> row2Children = [];
      row2Children.add(Expanded(child: _CustomMiniChip(label: displayed[2])));
      row2Children.add(SizedBox(width: 4.w));
      if (hasMore) {
        row2Children.add(
          Expanded(
            child: _CustomMiniChip(label: '+$moreCount more', isMoreChip: true),
          ),
        );
      } else if (displayed.length > 3) {
        row2Children.add(Expanded(child: _CustomMiniChip(label: displayed[3])));
      } else {
        row2Children.add(const Expanded(child: SizedBox.shrink()));
      }
      rows.add(
        Padding(
          padding: EdgeInsets.only(top: 4.h),
          child: Row(children: row2Children),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: rows,
    );
  }

  Widget _actionsRow() {
    final IconData leftIcon;
    final Color leftColor;
    final IconData rightIcon;
    final Color rightColor;

    if (activeFilter == 'Sent' || activeFilter == 'Matched') {
      leftIcon = Icons.star_rounded;
      leftColor = const Color(0xFFFFB000); // yellow star
      rightIcon = Icons.near_me_rounded;
      rightColor = const Color(0xFF22C55E); // green plane
    } else if (activeFilter == 'Favorites') {
      leftIcon = Icons.favorite_rounded;
      leftColor = AppColors.brand; // brand pink heart
      rightIcon = Icons.near_me_rounded;
      rightColor = const Color(0xFF22C55E); // green plane
    } else {
      leftIcon = Icons.close_rounded;
      leftColor = const Color(0xFFEF4444); // red cross
      rightIcon = Icons.favorite_rounded;
      rightColor = const Color(0xFF22C55E); // exact green heart from mockup!
    }

    return Row(
      children: [
        Expanded(
          child: _pillBtn(icon: leftIcon, color: leftColor, onTap: onNope),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _pillBtn(icon: rightIcon, color: rightColor, onTap: onLike),
        ),
      ],
    );
  }

  Widget _pillBtn({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 40.h,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Center(
          child: Icon(icon, color: color, size: 20.r),
        ),
      ),
    );
  }
}

/// Small frosted-glass dark capsule used for local interest tags.
class _CustomMiniChip extends StatelessWidget {
  const _CustomMiniChip({required this.label, this.isMoreChip = false});

  final String label;
  final bool isMoreChip;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22.h,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: isMoreChip
            ? Colors.white.withValues(alpha: 0.22)
            : Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(100.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 0.5.w,
        ),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 9.5.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
