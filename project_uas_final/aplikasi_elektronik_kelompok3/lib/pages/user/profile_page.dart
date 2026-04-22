import 'package:aplikasi_elektronik_kelompok3/main.dart';
import 'package:aplikasi_elektronik_kelompok3/pages/user/login_page.dart';
import 'package:aplikasi_elektronik_kelompok3/pages/user/address.dart';
import 'package:aplikasi_elektronik_kelompok3/pages/user/editprofile.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_elektronik_kelompok3/pages/user/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:aplikasi_elektronik_kelompok3/pages/user/faqs.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, dynamic>? userProfile;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  bool isNotificationOn = false;

  // Function to fetch user profile from Supabase
  Future<void> _fetchUserProfile() async {
    String userId = supabase.auth.currentUser!.id;
    final response =
        await supabase.from('Pelanggan').select().eq('id', userId).single();

    setState(() {
      userProfile = response;
    });
  }

  // Function to sign out
  Future<void> signOut() async {
    await supabase.auth.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false, // This removes all previous routes
    );
  }

  // Function to show the logout confirmation dialog
  Future<void> _showLogoutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: RichText(
            text: const TextSpan(
              style: TextStyle(color: Colors.black),
              children: [
                TextSpan(text: 'Are you sure you want to '),
                TextSpan(
                  text: 'log out?',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            ElevatedButton(child: const Text('Yes'), onPressed: signOut),
          ],
        );
      },
    );
  }

  // Main widget for the profile page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userProfile == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                color: const Color(0xFFebeaf6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    // Profile picture with circular shadow
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: userProfile!['ImageUrl'] != null
                          ? NetworkImage(
                              "${userProfile!['ImageUrl']}?v=${DateTime.now().millisecondsSinceEpoch}")
                          : const AssetImage("assets/profile.jpg")
                              as ImageProvider,
                      backgroundColor: Colors.white,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      userProfile!['nama'] ?? 'No Name',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),

                    const SizedBox(height: 20),
                    // Profile options
                    _buildProfileOption(
                      icon: Icons.edit, // Updated icon
                      text: 'Edit Profile',
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfileScreen()),
                        );
                        _fetchUserProfile(); // Fetch updated profile after edit
                      },
                    ),
                    _buildProfileOption(
                      icon: Icons.location_on, // Updated icon
                      text: 'Addresses',
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Address()));
                      },
                    ),
                    _buildProfileOption(
                      icon: Icons.notifications,
                      text: 'Notifikasi',
                      trailing: Switch(
                        value: isNotificationOn,
                        activeColor: Colors.green, // Warna saat ON
                        inactiveThumbColor: const Color.fromARGB(
                            255, 121, 121, 121), // Warna thumb saat OFF
                        inactiveTrackColor:
                            Colors.purple[300], // Warna track saat OFF
                        onChanged: (bool value) {
                          setState(() {
                            isNotificationOn = value;
                          });
                        },
                      ),
                      onTap: () {},
                    ),
                    _buildProfileOption(
                      icon: Icons.help_outline, // Icon untuk FAQS
                      text: 'FAQS',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  FAQS()), // Panggil halaman FAQS
                        );
                      },
                    ),
                    _buildProfileOption(
                      icon: Icons.logout,
                      text: 'Log Out',
                      textColor: Colors.red,
                      iconColor: Colors.red,
                      onTap: _showLogoutDialog,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // Widget for creating profile options
  Widget _buildProfileOption({
    required IconData icon,
    required String text,
    Widget? trailing,
    Color textColor = Colors.black,
    Color iconColor = Colors.black,
    required Function() onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            spreadRadius: 1,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
