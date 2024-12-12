import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String role = 'customer';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            DropdownButton<String>(
              value: role,
              items: [
                DropdownMenuItem(value: 'admin', child: Text('Admin')),
                DropdownMenuItem(value: 'customer', child: Text('Customer')),
              ],
              onChanged: (value) {
                setState(() {
                  role = value!;
                });
              },
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                final email = emailController.text.trim();
                final password = passwordController.text.trim();

                // Gunakan AuthService untuk registrasi pengguna
                User? user = await Provider.of<AuthService>(context, listen: false).register(email, password, role);

                setState(() {
                  isLoading = false;
                });

                if (user != null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Registrasi berhasil!")));
                  Navigator.pop(context); // Kembali ke halaman login setelah registrasi berhasil
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Registrasi gagal!")));
                }
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
