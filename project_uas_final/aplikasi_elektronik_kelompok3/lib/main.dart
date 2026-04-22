import 'package:aplikasi_elektronik_kelompok3/pages/user/explore_page.dart';
import 'package:aplikasi_elektronik_kelompok3/pages/user/main_page.dart';
import 'package:aplikasi_elektronik_kelompok3/pages/user/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_elektronik_kelompok3/pages/user/aboutus_page.dart';
import 'package:aplikasi_elektronik_kelompok3/pages/user/cart_page.dart';
import 'package:aplikasi_elektronik_kelompok3/pages/user/history_page.dart';
import 'package:aplikasi_elektronik_kelompok3/pages/user/home_page.dart';
import 'package:aplikasi_elektronik_kelompok3/pages/user/login_page.dart';
import 'package:aplikasi_elektronik_kelompok3/pages/user/signup_page.dart';
import 'package:aplikasi_elektronik_kelompok3/pages/user/topup_page.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_elektronik_kelompok3/pages/admin/admin_home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://yofnymsakxxlzerchvgy.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlvZm55bXNha3h4bHplcmNodmd5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzIxNzM2OTUsImV4cCI6MjA0Nzc0OTY5NX0.u8aiU5UrzHd7dwqoeO_lQCXKaViAIphMcM13zxubsM8',
  );
  runApp(MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TechCity E-commerce',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.transparent, // Membuat transparan
      ),
      initialRoute: '/checkSession', // Arahkan ke halaman pengecekan session
      routes: {
        '/login': (context) => GradientBackground(LoginPage()),
        '/signup': (context) => GradientBackground(SignupPage()),
        '/main': (context) => GradientBackground(MainPage()),
        '/cart': (context) => GradientBackground(Cart()),
        '/topup': (context) => GradientBackground(TopUpPage()),
        '/history': (context) => GradientBackground(OrdersPage()),
        '/aboutus': (context) => GradientBackground(AboutUsPage()),
        '/admin': (context) => GradientBackground(AdminHomePage()),
        '/checkSession': (context) => CheckSessionPage(),
        '/explore': (context) => GradientBackground(ExplorePage()),
        '/profile': (context) => GradientBackground(Profile()),
        '/home': (context) => GradientBackground(HomePage()),
      },
    );
  }
}

class GradientBackground extends StatelessWidget {
  final Widget child;

  GradientBackground(this.child);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFDAD5FB).withOpacity(0.9),
              Color(0xFFFFFFFF),
            ],
          ),
        ),
        child: child,
      ),
    );
  }
}

class CheckSessionPage extends StatefulWidget {
  @override
  _CheckSessionPageState createState() => _CheckSessionPageState();
}

class _CheckSessionPageState extends State<CheckSessionPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  // Mengecek session saat aplikasi dimulai
  Future<void> _checkSession() async {
    print("Checking session...");

    final ses = supabase.auth.currentSession;
    if (ses != null) {
      final userId = supabase.auth.currentUser!.id;
      final data = await supabase
          .from('Pelanggan')
          .select('isAdmin')
          .eq('id', userId)
          .single();

      if (!mounted) return; // Prevent navigating if widget is disposed

      if (data['isAdmin']) {
        Navigator.pushReplacementNamed(context, '/admin');
      } else {
        Navigator.pushReplacementNamed(context, '/main');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ses = supabase.auth.currentSession;
    if (ses == null) {
      // Use WidgetsBinding.addPostFrameCallback to navigate after the build phase
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
    }
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
