import 'package:es_warung_gapuro/screens/data/database.dart';
import 'package:es_warung_gapuro/screens/data/menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MenuInfoScreen extends StatefulWidget {
  final String brandId;
  final String menuId;

  MenuInfoScreen({required this.brandId, required this.menuId});

  @override
  _MenuInfoScreenState createState() => _MenuInfoScreenState();
}

class _MenuInfoScreenState extends State<MenuInfoScreen> {
  int quantity = 1;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Informasi Menu')),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('brands')
            .doc(widget.brandId)
            .collection('menus')
            .doc(widget.menuId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return Center(child: Text('Menu tidak ditemukan.'));
          }

          var menu = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(menu['name'], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Harga: ${menu['price']}'),
                SizedBox(height: 8),
                Text('Deskripsi: ${menu['description']}'),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text('Pesan:'),
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        if (quantity > 1) {
                          setState(() {
                            quantity--;
                          });
                        }
                      },
                    ),
                    Text('$quantity'),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          quantity++;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    void _addToCart(String menuId, String name, String description, double price) async {
                      final userId = FirebaseAuth.instance.currentUser!.uid;

                      await FirebaseFirestore.instance.collection('cart').add({
                        'userId': userId,
                        'menuId': menuId,
                        'name': name,
                        'description': description,
                        'price': price,
                        'quantity': 1, // Jumlah default
                        'note': '', // Catatan kosong sebagai default
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ditambahkan ke keranjang')));
                    }

                    // Add the item to the cart (this will require cart logic)
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tambah keranjang')));
                  },
                  child: Text('Tambah keranjang'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
