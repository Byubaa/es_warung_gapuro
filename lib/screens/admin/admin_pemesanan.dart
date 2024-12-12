import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminOrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pesanan Masuk')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          var orders = snapshot.data!.docs.map((doc) {
            var orderData = doc.data() as Map<String, dynamic>;
            return ListTile(
              title: Text('Pesanan dari ${orderData['customerName']}'),
              subtitle: Text('Total: Rp${orderData['total']}'),
              onTap: () {
                // Navigasi ke rincian pesanan jika diperlukan
              },
            );
          }).toList();

          return ListView(children: orders);
        },
      ),
    );
  }
}
