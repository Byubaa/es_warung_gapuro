import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'EditMenuScreen.dart';
import 'add_menu_screen.dart';
import 'admin_pemesanan.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController hoursController = TextEditingController();
  bool isBrandRegistered = false;
  String? brandId;

  @override
  void initState() {
    super.initState();
    _checkBrandStatus();
  }

  // Mengecek apakah admin sudah mengisi data brand atau belum
  Future<void> _checkBrandStatus() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final brandSnapshot = await FirebaseFirestore.instance
        .collection('brands')
        .where('adminId', isEqualTo: userId)
        .get();

    if (brandSnapshot.docs.isNotEmpty) {
      setState(() {
        isBrandRegistered = true;
        brandId = brandSnapshot.docs.first.id;
      });
    }
  }

  // Fungsi untuk menambahkan brand ke Firestore
  Future<void> addBrand() async {
    final name = nameController.text.trim();
    final address = addressController.text.trim();
    final hours = hoursController.text.trim();
    final userId = FirebaseAuth.instance.currentUser!.uid;

    if (name.isNotEmpty && address.isNotEmpty && hours.isNotEmpty) {
      final brandDoc = await FirebaseFirestore.instance.collection('brands').add({
        'adminId': userId,
        'name': name,
        'address': address,
        'hours': hours,
      });
      setState(() {
        isBrandRegistered = true;
        brandId = brandDoc.id;
      });
      nameController.clear();
      addressController.clear();
      hoursController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill all fields.")));
    }
  }

  // Fungsi untuk menambah menu
  Future<void> addMenu(String menuName) async {
    if (brandId != null && menuName.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('brands')
          .doc(brandId)
          .collection('menus')
          .add({'name': menuName});
      setState(() {}); // Update UI
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WARESGA'),
        leading: IconButton(
          icon: Icon(Icons.logout),
          onPressed: () async {
            // Logout pengguna menggunakan FirebaseAuth
            await FirebaseAuth.instance.signOut();
            // Arahkan ke layar login setelah logout
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              // Navigasi ke layar AdminOrderScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminOrderScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isBrandRegistered
            ? Column(
          children: [
            // Menampilkan informasi brand
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('brands').doc(brandId).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var brandData = snapshot.data!.data() as Map<String, dynamic>;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Brand: ${brandData['name']}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("Address: ${brandData['address']}"),
                      Text("Hours: ${brandData['hours']}"),
                      SizedBox(height: 20),
                    ],
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            Divider(),
            // Menampilkan menu atau pesan jika belum ada menu
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('brands').doc(brandId).collection('menus').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  return Expanded(
                    child: ListView(
                      children: snapshot.data!.docs.map((doc) {
                        var menuData = doc.data() as Map<String, dynamic>;
                        return ListTile(
                          title: Text(menuData['name']),
                          onTap: () {
                            // Navigasi ke EditMenuScreen untuk mengedit menu yang dipilih
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditMenuScreen(
                                  menuId: doc.id, // Mengirimkan menuId ke EditMenuScreen
                                  brandId: brandId!, // Mengirimkan brandId ke EditMenuScreen
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  );
                } else {
                  return Column(
                    children: [
                      Text("You don't have any menu yet."),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddMenuScreen(brandId: brandId!),
                            ),
                          );
                        },
                        child: Text("Add Menu?"),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        )
            : Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nama Brand'),
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(labelText: 'Alamat'),
            ),
            TextField(
              controller: hoursController,
              decoration: InputDecoration(labelText: 'Jam Buka'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: addBrand,
              child: Text('Daftar Brand'),
            ),
          ],
        ),
      ),
    );
  }
}
