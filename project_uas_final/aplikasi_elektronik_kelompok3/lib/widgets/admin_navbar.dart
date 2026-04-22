import 'package:flutter/material.dart';

class AdminNavbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  AdminNavbar({required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Product"),
        BottomNavigationBarItem(icon: Icon(Icons.assignment), label: "Status"),
        BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: "Profit"),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.purple,
      onTap: onTap,
    );
  }
}
