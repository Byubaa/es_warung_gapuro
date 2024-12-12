import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'MenuInfoScreen.dart';

class BrandInfoScreen extends StatelessWidget {
  final String brandId;

  BrandInfoScreen({required this.brandId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Informasi Brand')),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('brands').doc(brandId).get(),
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
                Text('Nama Brand: ${brand['name']}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Alamat: ${brand['address']}'),
                SizedBox(height: 8),
                Text('Jam buka: ${brand['hours']}'),
                SizedBox(height: 16),
                Text('Menu', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('brands')
                      .doc(brandId)
                      .collection('menus')
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('Menu belum tersedia.'));
                    }

                    var menus = snapshot.data!.docs;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: menus.length,
                      itemBuilder: (context, index) {
                        var menu = menus[index];
                        return ListTile(
                          title: Text(menu['name']),
                          subtitle: Text('Harga: ${menu['price']}'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MenuInfoScreen(
                                  brandId: brandId,
                                  menuId: menu.id,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
