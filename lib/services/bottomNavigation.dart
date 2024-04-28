import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onNavigationItemSelected;

  BottomNavigation({
    required this.selectedIndex,
    required this.onNavigationItemSelected,
  });

  BottomNavigationBarItem _buildIcon(int index, IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onNavigationItemSelected,
      type: BottomNavigationBarType.fixed,
      items: [
        _buildIcon(0, Icons.home, 'Home'),
        _buildIcon(1, Icons.star, 'Metas'),
        _buildIcon(2, Icons.equalizer, 'Registrar'),
        _buildIcon(3, Icons.share, 'Relatórios'),
        _buildIcon(4, Icons.person, 'Perfil'),
      ],
    );
  }
}
