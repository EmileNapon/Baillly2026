import 'package:flutter/material.dart';
import '../../features/Logements/presentation/screens/homePage.dart';

class BuildBottomBar extends StatefulWidget {
  const BuildBottomBar({super.key});

  @override
  State<BuildBottomBar> createState() => _BuildBottomBarState();
}

class _BuildBottomBarState extends State<BuildBottomBar> {
  int _selectedTab = 0;

  final tabs = [
    _TabData(page: HomePage(), icon: Icons.home_outlined, label: 'Accueil'),
    _TabData(page: HomePage(), icon: Icons.home_work_outlined, label: 'Logements'),
    _TabData(page: HomePage(), icon: Icons.work_outline, label: 'Artisans'),
    _TabData(page: HomePage(), icon: Icons.person_outline, label: 'Profil'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedTab,
        children: tabs.map((tab) => tab.page).toList(),
      ),

      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black12,
            )
          ],
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: tabs.asMap().entries.map((entry) {
            final i = entry.key;
            final tab = entry.value;
            final isActive = _selectedTab == i;

            return GestureDetector(
              onTap: () => setState(() => _selectedTab = i),

              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive ? Colors.black : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Row(
                  children: [
                    Icon(
                      tab.icon,
                      color: isActive ? Colors.white : Colors.grey,
                    ),

                    AnimatedSize(
                      duration: const Duration(milliseconds: 200),
                      child: isActive
                          ? Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                tab.label,
                                style: const TextStyle(color: Colors.white),
                              ),
                            )
                          : const SizedBox(),
                    )
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _TabData {
  final Widget page;
  final IconData icon;
  final String label;

  _TabData({
    required this.page,
    required this.icon,
    required this.label,
  });
}