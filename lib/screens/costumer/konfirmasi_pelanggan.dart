import 'package:flutter/material.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final double totalPrice;
  String? selectedPaymentMethod; // Variabel untuk menyimpan metode pembayaran yang dipilih

  OrderConfirmationScreen({required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Konfirmasi Pesanan')),
      body: Column(
        children: [
          ListTile(
            title: Text(
              'Total Tagihan: Rp$totalPrice',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            title: Text('Pilih Metode Pembayaran'),
            trailing: DropdownButton<String>(
              value: selectedPaymentMethod,
              hint: Text('Pilih'),
              items: [
                DropdownMenuItem(value: 'gopay', child: Text('GoPay')),
                DropdownMenuItem(value: 'virtual_account', child: Text('Virtual Account')),
              ],
              onChanged: (value) {
                selectedPaymentMethod = value;
              },
            ),
          ),
          Spacer(),
          ElevatedButton(
            onPressed: () {
              if (selectedPaymentMethod == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Pilih metode pembayaran terlebih dahulu')),
                );
              } else {
                _placeOrder(context);
              }
            },
            child: Text('Bayar Sekarang'),
          ),
        ],
      ),
    );
  }

  void _placeOrder(BuildContext context) {
    // Logika mengirim pesanan ke Firestore beserta total harga dan metode pembayaran
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pesanan berhasil dikirim ke admin dengan metode $selectedPaymentMethod')),
    );
    Navigator.pop(context);
  }
}
