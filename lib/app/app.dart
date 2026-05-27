import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_dimensions.dart';
import '../core/constants/app_strings.dart';
import '../core/theme/app_theme.dart';
import '../features/cities/presentation/providers/cities_provider.dart';
import '../features/fans/presentation/providers/fans_provider.dart';
import '../features/main_navigation/presentation/providers/bottom_nav_provider.dart';
import 'router/app_router.dart';
import 'router/app_routes.dart';

/// Root widget for the FanEasy application.
///
/// Wires up:
///   1. `ScreenUtil` for responsive sizing.
///   2. The app-wide [MultiProvider] tree.
///   3. The [MaterialApp] with theming and routing.
class FanEasyApp extends StatelessWidget {
  const FanEasyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(
        AppDimensions.designWidth,
        AppDimensions.designHeight,
      ),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => BottomNavProvider()),
          ChangeNotifierProvider(create: (_) => FansProvider()),
          ChangeNotifierProvider(create: (_) => CitiesProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppStrings.appTitle,
          theme: AppTheme.lightTheme,
          initialRoute: AppRoutes.root,
          onGenerateRoute: AppRouter.onGenerateRoute,
        ),
      ),
    );
  }
}
