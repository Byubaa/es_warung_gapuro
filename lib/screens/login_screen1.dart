import 'package:flutter/material.dart';
import 'data/login.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Hardcoded credentials
  final Login admin = Login("admin", "admin"); // username: admin, password: admin123
  final Login customer = Login("customer", "cust"); // username: customer, password: cust123

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Username field
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            // Password field
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true, // To hide password
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final username = usernameController.text;
                final password = passwordController.text;

                // Validation
                if (username == admin.username && password == admin.password) {
                  // Admin login
                  Navigator.pushReplacementNamed(context, '/admin');
                } else if (username == customer.username && password == customer.password) {
                  // Customer login
                  Navigator.pushReplacementNamed(context, '/customer');
                } else {
                  // Invalid credentials
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Login gagal: Username atau password salah'),
                  ));
                }
              },
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Registrasi dinonaktifkan untuk versi ini'),
                ));
              },
              child: Text('Buat Akun'),
            ),
          ],
        ),
      ),
    );
  }
}