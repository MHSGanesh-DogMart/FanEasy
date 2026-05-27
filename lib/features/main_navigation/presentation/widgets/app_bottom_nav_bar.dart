import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/bottom_nav_provider.dart';

/// Pill-shaped floating bottom navigation bar.
///
/// Reads the selected index from [BottomNavProvider] and dispatches tap
/// events back to it. Only the tapped tab rebuilds thanks to
/// `context.select`.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({super.key});

  static const _items = <_NavItem>[
    _NavItem(AppAssets.navFans, AppStrings.navFans),
    _NavItem(AppAssets.navCities, AppStrings.navCities),
    _NavItem(AppAssets.navFanPages, AppStrings.navFanPages),
    _NavItem(AppAssets.navLikes, AppStrings.navLikes),
    _NavItem(AppAssets.navChats, AppStrings.navChats),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.only(
        left: 20.w,
        top: 16.h,
        right: 20.w,
        bottom: 16.h + bottomSafe,
      ),
      color: Colors.transparent,
      child: Container(
        height: 62.h,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(_items.length, (i) {
            final item = _items[i];
            return Expanded(
              child: _NavTab(index: i, asset: item.asset, label: item.label),
            );
          }),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.asset, this.label);
  final String asset;
  final String label;
}

class _NavTab extends StatelessWidget {
  const _NavTab({
    required this.index,
    required this.asset,
    required this.label,
  });

  final int index;
  final String asset;
  final String label;

  @override
  Widget build(BuildContext context) {
    final selected = context.select<BottomNavProvider, bool>(
      (p) => p.currentIndex == index,
    );
    return GestureDetector(
      onTap: () => context.read<BottomNavProvider>().setIndex(index),
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 54.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.brandTint : Colors.transparent,
            borderRadius: BorderRadius.circular(100.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                asset,
                width: 20.r,
                height: 20.r,
                color: selected ? AppColors.brand : const Color(0xFF1C1C1E),
                colorBlendMode: BlendMode.srcIn,
              ),
              SizedBox(height: 2.h),
              Text(
                label,
                style: TextStyle(
                  color: selected ? AppColors.brand : const Color(0xFF1C1C1E),
                  fontSize: 13.sp,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
