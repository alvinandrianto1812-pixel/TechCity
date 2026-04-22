import 'package:flutter/material.dart';
import 'package:aplikasi_elektronik_kelompok3/pages/user/home_page.dart';
import 'package:aplikasi_elektronik_kelompok3/pages/user/explore_page.dart';
import 'package:aplikasi_elektronik_kelompok3/pages/user/profile_page.dart';
import 'package:aplikasi_elektronik_kelompok3/widgets/navbar_user.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0; // Default index for HomePage

  // List of pages to navigate to based on selected index
  final List<Widget> _pages = [
    HomePage(), // Home Page
    ExplorePage(), // Explore Page
    Profile(), // Profile Page
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: UserNavbar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped, // Handle navigation on tap
      ),
    );
  }
}
