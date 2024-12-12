import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'konfirmasi_pelanggan.dart';


class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: Text('Keranjang')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('cart').where('userId', isEqualTo: userId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          double totalPrice = 0;

          var cartItems = snapshot.data!.docs.map((doc) {
            var data = doc.data() as Map<String, dynamic>;
            totalPrice += data['price'] * data['quantity'];
            return ListTile(
              leading: Icon(Icons.fastfood), // Simbol produk
              title: Text(data['name']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data['description']),
                  TextField(
                    decoration: InputDecoration(labelText: 'Catatan'),
                    onChanged: (note) => FirebaseFirestore.instance.collection('cart').doc(doc.id).update({'note': note}),
                  ),
                  Row(
                    children: [
                      Text('Jumlah: ${data['quantity']}'),
                      Text(' Total: Rp${data['price'] * data['quantity']}'),
                    ],
                  ),
                ],
              ),
            );
          }).toList();

          return Column(
            children: [
              Expanded(child: ListView(children: cartItems)),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text('Total Keseluruhan: Rp$totalPrice', style: TextStyle(fontSize: 16)),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => OrderConfirmationScreen(totalPrice: totalPrice)),
                        );
                      },
                      child: Text('Beli'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
