import 'package:es_warung_gapuro/screens/data/admin.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/database.dart';
import '../data/menu.dart';
import 'MenuInfoScreen.dart';

class BrandInfoScreen2 extends StatefulWidget {
  final String brandId;

  BrandInfoScreen2({required this.brandId});

  @override
  State<BrandInfoScreen2> createState() => _BrandInfoScreen2State();
}

class _BrandInfoScreen2State extends State<BrandInfoScreen2> {

  Database database = Database([
    Menu('berasal dari teh pilihan', 'es teh', 10000),
    Menu('teh rasa susu', 'es teh susu', 20000),
    Menu('berasal dari teh pilihan', 'es teh', 10000)
  ]);
  Database1 database1 = Database1([
    Admin('ESKU', 'Serengan', 8),
    Admin('ESMU', 'PARAGON', 7),
    Admin('ESKITA', 'TIPES', 8),
    ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Informasi Brand')),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('brands').doc(widget.brandId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return Center(child: Text('Brand tidak ditemukan.'));
          }

          var brand = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: database1.admin.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Nama brand: ${database1.admin[index].name}'),
                      subtitle: Text('Alamat: ${database1.admin[index].address}'),
                      onTap: () {

                      },
                    );
                  },
                ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: database.menu.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(database.menu[index].name),
                  subtitle: Text('Harga: ${database.menu[index].price}'),
                  onTap: () {

                  },
                );
              },
            )

            ],
            ),
          );
        },
      ),
    );
  }
}
