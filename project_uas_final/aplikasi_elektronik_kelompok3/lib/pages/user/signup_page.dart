// import 'package:flutter/material.dart';

// class SignupPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFF5F3FF), // Warna lembut yang serasi
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Logo
//               Image.asset(
//                 'assets/logo.png', // Ganti dengan path logo Anda
//                 height: 200,
//                 fit: BoxFit.contain,
//               ),
//               SizedBox(height: 8),
//               SizedBox(height: 20),

//               // Username Field
//               TextField(
//                 decoration: InputDecoration(
//                   prefixIcon: Icon(Icons.person, color: Color(0xFF4A148C)),
//                   labelText: 'Username',
//                   labelStyle: TextStyle(color: Color(0xFF4A148C)),
//                   filled: true,
//                   fillColor: Colors.white,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: BorderSide.none,
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: BorderSide(
//                       color: Color(0xFF4A148C),
//                       width: 2,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 16),

//               // Email Field
//               TextField(
//                 decoration: InputDecoration(
//                   prefixIcon: Icon(Icons.email, color: Color(0xFF4A148C)),
//                   labelText: 'Email',
//                   labelStyle: TextStyle(color: Color(0xFF4A148C)),
//                   filled: true,
//                   fillColor: Colors.white,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: BorderSide.none,
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: BorderSide(
//                       color: Color(0xFF4A148C),
//                       width: 2,
//                     ),
//                   ),
//                 ),
//                 keyboardType: TextInputType.emailAddress,
//               ),
//               SizedBox(height: 16),

//               // Password Field
//               TextField(
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   prefixIcon: Icon(Icons.lock, color: Color(0xFF4A148C)),
//                   suffixIcon: IconButton(
//                     icon: Icon(Icons.visibility, color: Color(0xFF6A1B9A)),
//                     onPressed: () {
//                       // Tambahkan logika untuk toggle visibility
//                     },
//                   ),
//                   labelText: 'Password',
//                   labelStyle: TextStyle(color: Color(0xFF4A148C)),
//                   filled: true,
//                   fillColor: Colors.white,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: BorderSide.none,
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: BorderSide(
//                       color: Color(0xFF4A148C),
//                       width: 2,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 16),

//               // Confirm Password Field
//               TextField(
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   prefixIcon: Icon(Icons.lock, color: Color(0xFF4A148C)),
//                   suffixIcon: IconButton(
//                     icon: Icon(Icons.visibility, color: Color(0xFF6A1B9A)),
//                     onPressed: () {
//                       // Tambahkan logika untuk toggle visibility
//                     },
//                   ),
//                   labelText: 'Confirm Password',
//                   labelStyle: TextStyle(color: Color(0xFF4A148C)),
//                   filled: true,
//                   fillColor: Colors.white,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: BorderSide.none,
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: BorderSide(
//                       color: Color(0xFF4A148C),
//                       width: 2,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),

//               // Sign Up Button
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context); // Kembali ke LoginPage
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xFF4A148C),
//                   padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: Text(
//                   'Sign Up',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),

//               // Already have an account?
//               SizedBox(height: 20),
//               GestureDetector(
//                 onTap: () {
//                   Navigator.pushNamed(context, '/login');
//                 },
//                 child: Text(
//                   "Already have an account? Login here",
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF6A1B9A),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  final phoneController = TextEditingController();
  bool _passwordVisible = false;

  Future<void> signUp() async {
    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        data: {
          'username': usernameController.text.trim(),
          'phone': phoneController.text.trim(),
        },
      );

      if (response.user != null) {
        await Supabase.instance.client.from('Pelanggan').insert([
          {
            'id': response.user!.id,
            'nama': usernameController.text.trim(),
            'email': emailController.text.trim(),
            'no_hp': phoneController.text.trim(),
          },
        ]);
        Navigator.pushReplacementNamed(context, '/login');
      }
    } on AuthException catch (e) {
      print(e.message);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F3FF), // Warna lembut yang serasi
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'assets/logo.png', // Ganti dengan path logo Anda
                height: 120,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 8),
              Text(
                "TECHCITY",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A148C), // Warna utama ungu dari logo
                ),
              ),
              Text(
                "Your One-Stop Tech Destination",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6A1B9A), // Warna ungu sekunder
                ),
              ),
              SizedBox(height: 40),

              // Username Field
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person, color: Color(0xFF4A148C)),
                  labelText: 'Username',
                  labelStyle: TextStyle(color: Color(0xFF4A148C)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Color(0xFF4A148C),
                      width: 2,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Email Field
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email, color: Color(0xFF4A148C)),
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Color(0xFF4A148C)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Color(0xFF4A148C),
                      width: 2,
                    ),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),

              // Phone Field
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone, color: Color(0xFF4A148C)),
                  labelText: 'No Handphone',
                  labelStyle: TextStyle(color: Color(0xFF4A148C)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Color(0xFF4A148C),
                      width: 2,
                    ),
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16),

              // Password Field
              TextField(
                controller: passwordController,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock, color: Color(0xFF4A148C)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Color(0xFF6A1B9A),
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Color(0xFF4A148C)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Color(0xFF4A148C),
                      width: 2,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Sign Up Button
              ElevatedButton(
                onPressed: signUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4A148C),
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              // Already have an account?
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Text(
                  "Already have an account? Login here",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6A1B9A),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}