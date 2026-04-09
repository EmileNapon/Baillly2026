import 'package:flutter/material.dart';
import '../../features/Logements/presentation/screens/homePage.dart';

class BuildBottomBar extends StatefulWidget {
  const BuildBottomBar({super.key});

  @override
  State<BuildBottomBar> createState() => _BuildBottomBarState();
}

class _BuildBottomBarState extends State<BuildBottomBar> {
  int _selectedTab = 0;

  late final List<_TabData> tabs = [
    _TabData(
      page: const HomePage(),
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Maisons',
    ),
    _TabData(
      page: const Center(child: Text('Carte')),
      icon: Icons.map_outlined,
      activeIcon: Icons.map,
      label: 'Carte',
    ),
    _TabData(
      page: const Center(child: Text('Artisans')),
      icon: Icons.work_outline,
      activeIcon: Icons.work,
      label: 'Artisans',
    ),
    _TabData(
      page: const Center(child: Text('Messages')),
      icon: Icons.chat_bubble_outline,
      activeIcon: Icons.chat_bubble,
      label: 'Discussions',
    ),
    _TabData(
      page: const Center(child: Text('Profil')),
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Vous',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: IndexedStack(
        index: _selectedTab,
        children: tabs.map((tab) => tab.page).toList(),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(top: 10, bottom: 16, left: 8, right: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(tabs.length, (index) {
            final tab = tabs[index];
            final isActive = _selectedTab == index;

            return GestureDetector(
              onTap: () => setState(() => _selectedTab = index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icône avec fond vert clair si actif (style WhatsApp)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color(0xFF25D366).withOpacity(0.15)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      isActive ? tab.activeIcon : tab.icon,
                      color: isActive
                          ? const Color(0xFF128C7E) // vert WhatsApp foncé
                          : Colors.grey[600],
                      size: 26,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Label
                  Text(
                    tab.label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isActive
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isActive
                          ? const Color(0xFF128C7E)
                          : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _TabData {
  final Widget page;
  final IconData icon;
  final IconData activeIcon;
  final String label;

  _TabData({
    required this.page,
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}