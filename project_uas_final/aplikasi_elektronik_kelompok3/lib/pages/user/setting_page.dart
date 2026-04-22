import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  final List<Map<String, dynamic>> settings = [
    {"title": "Edit Profile", "icon": Icons.edit},
    {"title": "Address Management", "icon": Icons.location_on},
    {"title": "Notifications", "icon": Icons.notifications_active},
    {"title": "FAQs", "icon": Icons.help_outline},
    {"title": "Logout", "icon": Icons.logout},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF4A148C),
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Bagian Profil
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/logo.png'),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "User", // Nama pengguna
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A148C),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Menu Settings
            Expanded(
              child: ListView.builder(
                itemCount: settings.length,
                itemBuilder: (context, index) {
                  final item = settings[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Icon(
                        item["icon"],
                        color: Color(0xFF4A148C),
                      ),
                      title: Text(
                        item["title"],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A148C),
                        ),
                      ),
                      trailing: item["title"] == "Notifications"
                          ? Switch(
                              value: true, // Nilai default
                              onChanged: (value) {
                                // Logika untuk notifikasi
                              },
                            )
                          : null,
                      onTap: () {
                        if (item["title"] == "Logout") {
                          _showLogoutDialog(context);
                        } else {
                          // Tambahkan navigasi untuk setiap item
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Logout",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (route) => false); // Navigasi ke login
              },
              child: Text(
                "Logout",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
