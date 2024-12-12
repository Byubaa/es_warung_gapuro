import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class AddMenuScreen extends StatefulWidget {
  final String brandId; // Brand ID as reference to the brand collection

  AddMenuScreen({required this.brandId});

  @override
  _AddMenuScreenState createState() => _AddMenuScreenState();
}

class _AddMenuScreenState extends State<AddMenuScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  File? _menuImage; // No longer needed for upload
  bool isLoading = false;

  // Set the default image here (you can place an image in your assets folder)
  final String defaultImageUrl = 'assets/default_image.png';

  // Function to save menu to Firestore
  Future<void> _addMenu() async {
    if (nameController.text.isEmpty || priceController.text.isEmpty || descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all fields.')));
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Save menu data to Firestore with the default image URL
      await FirebaseFirestore.instance
          .collection('brands')
          .doc(widget.brandId)
          .collection('menus')
          .add({
        'name': nameController.text,
        'price': priceController.text,
        'description': descriptionController.text,
        'imageUrl': defaultImageUrl, // Using default image URL
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Menu added successfully!')));
      Navigator.pop(context); // Navigate back to AdminScreen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add menu: $e')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('WARESGA')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                // Here you can implement the functionality for editing the menu image if needed
              },
              child: Container(
                width: 100,
                height: 100,
                color: Colors.grey[300],
                child: Image.asset(defaultImageUrl, fit: BoxFit.cover), // Use default image
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nama Menu'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Harga'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Deskripsi'),
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _addMenu,
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
