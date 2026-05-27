import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// "LIKE" / "NOPE" stamp that fades in as the top card is swiped.
class SwipeOverlay extends StatelessWidget {
  const SwipeOverlay({
    super.key,
    required this.label,
    required this.color,
    required this.opacity,
    required this.alignment,
  });

  final String label;
  final Color color;
  final double opacity;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final isLeftAligned = alignment == Alignment.topLeft;
    return ClipRRect(
      borderRadius: BorderRadius.circular(22.r),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22.r),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: isLeftAligned
                ? [color.withValues(alpha: opacity * 0.35), Colors.transparent]
                : [Colors.transparent, color.withValues(alpha: opacity * 0.35)],
          ),
        ),
        child: Align(
          alignment: alignment,
          child: Padding(
            padding: EdgeInsets.all(24.r),
            child: Transform.rotate(
              angle: isLeftAligned ? -0.35 : 0.35,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                decoration: BoxDecoration(
                  border: Border.all(color: color, width: 2.5),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
