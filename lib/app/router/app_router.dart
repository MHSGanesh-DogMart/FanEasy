import 'package:flutter/material.dart';

import '../../features/cities/presentation/screens/fans_in_miami_screen.dart';
import '../../features/cities/presentation/screens/miami_fanpages_screen.dart';
import '../../features/cities/presentation/screens/miami_matches_screen.dart';
import '../../features/fan_pages/presentation/screens/fan_page_detail_screen.dart';
import '../../features/main_navigation/presentation/screens/main_screen.dart';
import 'app_routes.dart';

/// Centralised `onGenerateRoute` so new screens can be wired up here
/// instead of scattering `MaterialPageRoute` calls across the codebase.
class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.root:
        return _buildRoute(settings, const MainScreen());
      case AppRoutes.miamiFans:
        return _buildRoute(settings, const FansInMiamiScreen());
      case AppRoutes.miamiFanPages:
        return _buildRoute(settings, const MiamiFanPagesScreen());
      case AppRoutes.miamiMatches:
        return _buildRoute(settings, const MiamiMatchesScreen());
      case AppRoutes.fanPageDetail:
        return _buildRoute(settings, const FanPageDetailScreen());
      default:
        return _buildRoute(settings, const MainScreen());
    }
  }

  static MaterialPageRoute<dynamic> _buildRoute(
    RouteSettings settings,
    Widget page,
  ) =>
      MaterialPageRoute(settings: settings, builder: (_) => page);
}
