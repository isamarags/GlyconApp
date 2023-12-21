import 'package:flutter/material.dart';

class CustomBottomNavigationBarItem extends StatelessWidget {
  final int index;
  final IconData icon;
  final String label;
  final int selectedIndex;
  final VoidCallback? onTap;

  CustomBottomNavigationBarItem({
    required this.index,
    required this.icon,
    required this.label,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == selectedIndex;
    final color = isSelected ? Color(0xFFBA8383) : Color(0xFFEFDFD8);

    return GestureDetector(
      onTap: onTap, // Use onTap diretamente
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color),
          Text(label, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}
