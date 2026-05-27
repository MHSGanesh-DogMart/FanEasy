import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../chats/presentation/screens/chats_screen.dart';
import '../../../cities/presentation/screens/cities_screen.dart';
import '../../../fan_pages/presentation/screens/fan_pages_screen.dart';
import '../../../fans/presentation/screens/fans_screen.dart';
import '../../../likes/presentation/screens/likes_screen.dart';
import '../providers/bottom_nav_provider.dart';
import '../widgets/app_bottom_nav_bar.dart';

/// Root scaffold of the app — owns the bottom navigation bar and an
/// `IndexedStack` so each tab keeps its own state when the user swaps
/// between them.
///
/// Tab order matches the bottom nav: Fans, Cities, Fan Pages, Likes,
/// Chats.
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  static const _tabs = <Widget>[
    FansScreen(),
    CitiesScreen(),
    FanPagesScreen(),
    LikesScreen(),
    ChatsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final index = context.select<BottomNavProvider, int>((p) => p.currentIndex);
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: IndexedStack(index: index, children: _tabs),
      bottomNavigationBar: const AppBottomNavBar(),
    );
  }
}
