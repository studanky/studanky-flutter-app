import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:studanky_flutter_app/l10n/extension.dart';

class BottomNavigationScaffold extends StatelessWidget {
  const BottomNavigationScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onItemTapped(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.map),
            label: context.l10n.bottom_nav_bar_item_map,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.qr_code),
            label: context.l10n.bottom_nav_bar_item_scanner,
          ),
        ],
      ),
    );
  }
}
