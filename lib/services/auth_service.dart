import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fungsi login dengan email dan password
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } on FirebaseAuthException catch (e) {
      print("Login Error: ${e.message}");
      return null;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  // Fungsi registrasi untuk membuat user baru
  Future<User?> register(String email, String password, String role) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'role': role,
        });
      }
      return user;
    } on FirebaseAuthException catch (e) {
      print("Registration Error: ${e.message}");
      return null;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  // Fungsi untuk logout
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Fungsi untuk mendapatkan role user saat ini
  Future<String?> getCurrentUserRole() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await _firestore.collection('users').doc(user.uid).get();
      return snapshot['role'] as String?;
    }
    return null; // Mengembalikan null jika user tidak login
  }
}
