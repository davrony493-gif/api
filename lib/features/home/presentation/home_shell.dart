import 'package:flutter/material.dart';

import '../../../core/strings.dart';
import '../../../core/widgets/liquid_glass_navigation_bar.dart';
import '../../auth/data/auth_service.dart';
import 'tabs/home_tab.dart';
import 'tabs/profile_tab.dart';
import 'tabs/search_tab.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.user});

  final AppUser user;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack keeps each tab's state (scroll, search text) alive.
      body: IndexedStack(
        index: _index,
        children: [
          HomeTab(user: widget.user),
          const SearchTab(),
          ProfileTab(user: widget.user),
        ],
      ),
      bottomNavigationBar: LiquidGlassNavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          LiquidGlassNavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: AppStrings.tabHome,
          ),
          LiquidGlassNavigationDestination(
            icon: Icon(Icons.search_rounded),
            label: AppStrings.tabSearch,
          ),
          LiquidGlassNavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: AppStrings.tabProfile,
          ),
        ],
      ),
    );
  }
}
