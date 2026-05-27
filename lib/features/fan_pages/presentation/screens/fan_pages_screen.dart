import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/placeholder_screen.dart';

class FanPagesScreen extends StatelessWidget {
  const FanPagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: AppStrings.navFanPages,
      icon: Icons.public_outlined,
    );
  }
}
