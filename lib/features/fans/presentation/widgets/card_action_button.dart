import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Pill-shaped icon button used in the profile card's action row.
class CardActionButton extends StatelessWidget {
  const CardActionButton({
    super.key,
    this.icon,
    this.iconWidget,
    required this.color,
    required this.height,
    this.width,
    this.onTap,
  }) : assert(icon != null || iconWidget != null,
            'Provide either icon or iconWidget');

  final IconData? icon;
  final Widget? iconWidget;
  final Color color;
  final double height;
  final double? width;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? height,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.cardActionBg.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(height * 0.5),
        ),
        child: Center(
          child: iconWidget ?? Icon(icon, color: color, size: height * 0.44),
        ),
      ),
    );
  }
}
