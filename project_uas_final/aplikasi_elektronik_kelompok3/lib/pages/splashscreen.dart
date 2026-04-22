import 'package:aplikasi_elektronik_kelompok3/pages/user/home_page.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F4F9), // Warna latar terang
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'assets/logo.png', // Ganti dengan lokasi logo Anda
              height: 150,
            ),
            SizedBox(height: 20),
            // Judul Aplikasi

            SizedBox(height: 10),
            // Deskripsi
            Text(
              'Your Electronics Ecommerce Solution!',
              style: TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreenWrapper(),
  ));
}

class SplashScreenWrapper extends StatefulWidget {
  @override
  _SplashScreenWrapperState createState() => _SplashScreenWrapperState();
}

class _SplashScreenWrapperState extends State<SplashScreenWrapper> {
  @override
  void initState() {
    super.initState();
    // Navigasi otomatis setelah 3 detik
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) =>
                HomePage()), // Ganti NextScreen ke layar tujuan
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}
