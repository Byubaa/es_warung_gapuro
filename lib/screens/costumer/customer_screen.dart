import 'package:es_warung_gapuro/screens/costumer/BrandInfoScreen2.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'BrandInfoScreen.dart';
import 'konfirmasi_pelanggan.dart';

class CustomerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Misalnya, total harga default atau hitung di sini jika sudah diketahui
    final double totalPrice = 0.0; // Ganti ini sesuai logika perhitungan total harga

    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Brand'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderConfirmationScreen(totalPrice: totalPrice), // Sertakan totalPrice
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('brands').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Belum ada brand.'));
          }

          var brands = snapshot.data!.docs;

          return ListView.builder(
            itemCount: brands.length,
            itemBuilder: (context, index) {
              var brand = brands[index];

              return ListTile(
                title: Text(brand['name']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BrandInfoScreen2(brandId: brand.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
