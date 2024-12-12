import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class LoginScreen1 extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Email field
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            // Password field
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true, // To hide password
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final email = emailController.text;
                final password = passwordController.text;

                try {
                  User? user = await Provider.of<AuthService>(context, listen: false).signIn(email, password);
                  if (user != null) {
                    String? role = await Provider.of<AuthService>(context, listen: false).getCurrentUserRole();
                    if (role == 'admin') {
                      Navigator.pushReplacementNamed(context, '/admin');
                    } else {
                      Navigator.pushReplacementNamed(context, '/customer');
                    }
                  }
                } catch (e) {
                  // Show error message if login failed
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login gagal: ${e.toString()}')));
                }
              },
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () {
                // Navigate to the Register screen
                Navigator.pushNamed(context, '/register');
              },
              child: Text('Buat Akun'),
            ),
          ],
        ),
      ),
    );
  }
}
