import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';

class NewLikesScreen extends StatefulWidget {
  const NewLikesScreen({super.key});

  @override
  State<NewLikesScreen> createState() => _NewLikesScreenState();
}

class _NewLikesScreenState extends State<NewLikesScreen> {
  // Mock profiles for the "New Likes" screen matching the user mockup
  final List<_MockNewLikeProfile> _profiles = [
    _MockNewLikeProfile(
      name: 'Hudson, 27',
      flag: '🇺🇸',
      country: 'USA',
      imageUrl: 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=800',
      matchPercentage: 95,
    ),
    _MockNewLikeProfile(
      name: 'Emily, 22',
      flag: '🇺🇸',
      country: 'USA',
      imageUrl: 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=800',
    ),
    _MockNewLikeProfile(
      name: 'John Smith, 35',
      flag: '🇺🇸',
      country: 'USA',
      imageUrl: 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=800',
    ),
    _MockNewLikeProfile(
      name: 'John Smith, 35',
      flag: '🇺🇸',
      country: 'USA',
      imageUrl: 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=800',
    ),
    _MockNewLikeProfile(
      name: 'Hudson, 27',
      flag: '🇺🇸',
      country: 'USA',
      imageUrl: 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=800',
      matchPercentage: 95,
    ),
    _MockNewLikeProfile(
      name: 'Emily, 22',
      flag: '🇺🇸',
      country: 'USA',
      imageUrl: 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=800',
      matchPercentage: 95,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAF9F6),
      body: SafeArea(
        child: Column(
          children: [
            // ── Custom App Bar ───────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 14.h),
              child: Row(
                children: [
                  // Premium Double Heart icon
                  Image.asset(
                    AppAssets.doubleHeartIcon,
                    width: 28.r,
                    height: 28.r,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'New Likes',
                    style: GoogleFonts.inter(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const Spacer(),
                  // Premium circular close button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 38.r,
                      height: 38.r,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFEEEEEE),
                          width: 1.w,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        size: 20.r,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Grid content ─────────────────────────────────────────────
            Expanded(
              child: _profiles.isEmpty
                  ? Center(
                      child: Text(
                        'No new likes remaining',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: const Color(0xFF9E9E9E),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : GridView.builder(
                      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 20.h),
                      itemCount: _profiles.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 150 / 220,
                        crossAxisSpacing: 12.w,
                        mainAxisSpacing: 12.h,
                      ),
                      itemBuilder: (context, index) {
                        return _NewLikeGridTile(
                          profile: _profiles[index],
                          onNope: () {
                            setState(() {
                              _profiles.removeAt(index);
                            });
                          },
                          onLike: () {
                            setState(() {
                              _profiles.removeAt(index);
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
}

class _MockNewLikeProfile {
  _MockNewLikeProfile({
    required this.name,
    required this.flag,
    required this.country,
    required this.imageUrl,
    this.matchPercentage,
  });

  final String name;
  final String flag;
  final String country;
  final String imageUrl;
  final int? matchPercentage;
}

class _NewLikeGridTile extends StatelessWidget {
  const _NewLikeGridTile({
    required this.profile,
    required this.onNope,
    required this.onLike,
  });

  final _MockNewLikeProfile profile;
  final VoidCallback onNope;
  final VoidCallback onLike;

  @override
  Widget build(BuildContext context) {
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
            if (profile.matchPercentage != null)
              Positioned(
                top: 12.h,
                right: 12.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE13353),
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.favorite_rounded,
                        color: Colors.white,
                        size: 9.r,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        '${profile.matchPercentage}% Match',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Positioned(
              left: 12.w,
              right: 12.w,
              bottom: 12.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
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
                  ),
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
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: onNope,
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            height: 40.h,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.close_rounded,
                                color: const Color(0xFFEF4444),
                                size: 20.r,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: GestureDetector(
                          onTap: onLike,
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            height: 40.h,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.favorite_rounded,
                                color: const Color(0xFF22C55E),
                                size: 20.r,
                              ),
                            ),
                          ),
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
    );
  }
}
