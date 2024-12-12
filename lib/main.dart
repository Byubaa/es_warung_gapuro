import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/login_screen1.dart';
import './screens/register_screen.dart';
import './services/auth_service.dart';
import './screens/admin/admin_screen.dart';
import './screens/costumer/customer_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(apiKey: 'AIzaSyDRaX5JFKOdQ-zA4BXFCbFTCarl8zHgeBA', appId: '1:567736086479:android:2c64a94cf9cddfa0d36cba', messagingSenderId: '567736086479', projectId: 'esteh-31e1c')
  ); // Pastikan Firebase diinisialisasi
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: 'Aplikasi Login',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          '/': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/admin': (context) => AdminScreen(),
          '/customer': (context) => CustomerScreen(),
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return FutureBuilder(
      future: authService.getCurrentUserRole(), // Misalnya, mengambil role user
      builder: (context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Loading indicator
        } else if (snapshot.hasData) {
          // Jika user ada, cek apakah admin atau customer
          final role = snapshot.data;
          if (role == 'admin') {
            return AdminScreen();
          } else {
            return CustomerScreen();
          }
        } else {
          return LoginScreen(); // Jika belum login atau ada error
        }
      },
    );
  }
}
