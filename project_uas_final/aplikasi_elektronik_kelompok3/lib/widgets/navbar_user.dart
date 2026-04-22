import 'package:flutter/material.dart';

class UserNavbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  UserNavbar({required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Explore"),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.blue,
      onTap: onTap,
    );
  }
}
