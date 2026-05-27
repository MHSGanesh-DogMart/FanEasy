import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/fans_provider.dart';

/// AppBar contents for the Fans tab: filter pill, Single/Group segmented
/// control, Likes pill and the user avatar with a presence indicator.
class FansTopBar extends StatelessWidget implements PreferredSizeWidget {
  const FansTopBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(48.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.scaffoldBackground,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 48.h,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _filterButton(),
            const SizedBox(width: 8),
            Expanded(child: _segmentControl()),
            SizedBox(width: 12.w),
            _likesButton(),
            const SizedBox(width: 8),
            _avatar(),
          ],
        ),
      ),
    );
  }

  Widget _filterButton() {
    return Container(
      width: 44.r,
      height: 44.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.borderSubtle, width: 1),
      ),
      padding: EdgeInsets.all(8.r),
      child: Image.asset(AppAssets.filterIcon, height: 24.r, width: 24.r),
    );
  }

  Widget _segmentControl() {
    return Container(
      height: 44.h,
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackground,
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SegmentTab(
              label: AppStrings.tabSingle,
              segment: FansSegment.single,
            ),
          ),
          Expanded(
            child: _SegmentTab(
              label: AppStrings.tabGroup,
              segment: FansSegment.group,
            ),
          ),
        ],
      ),
    );
  }

  Widget _likesButton() {
    return Container(
      height: 44.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100.r),
        border: Border.all(color: AppColors.borderSubtle, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(AppAssets.heartIcon, height: 18.r, width: 18.r),
          SizedBox(width: 8.w),
          Text(
            AppStrings.likes,
            style: GoogleFonts.inter(
              color: const Color(0xff141414),
              fontWeight: FontWeight.w500,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatar() {
    return Stack(
      children: [
        CircleAvatar(
          radius: 22.r,
          backgroundImage: const NetworkImage(
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100&auto=format',
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: 12.r,
            height: 12.r,
            decoration: BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

class _SegmentTab extends StatelessWidget {
  const _SegmentTab({required this.label, required this.segment});

  final String label;
  final FansSegment segment;

  @override
  Widget build(BuildContext context) {
    final selected = context.select<FansProvider, bool>(
      (p) => p.segment == segment,
    );
    return GestureDetector(
      onTap: () => context.read<FansProvider>().setSegment(segment),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: selected ? AppColors.brandSoft : Colors.transparent,
          borderRadius: BorderRadius.circular(100.r),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: selected ? AppColors.brand : const Color(0xFF1C1C1E),
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }
}
