import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Us"),
        backgroundColor: Color(0xFF4A148C),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logoname.png', // Logo perusahaan
              height: 100,
              width: 100,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 16),
            Text(
              "Welcome to TechCity!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A148C),
              ),
            ),
            SizedBox(height: 16),
            Text(
              "TechCity adalah platform terpercaya untuk mendapatkan produk teknologi terbaik. "
              "Kami berkomitmen untuk memberikan pengalaman berbelanja yang mudah dan nyaman "
              "dengan produk-produk berkualitas tinggi.",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              "Contact Us",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A148C),
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Email: support@techcity.com\nPhone: +62 812 3456 7890",
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
