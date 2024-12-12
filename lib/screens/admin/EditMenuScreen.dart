import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditMenuScreen extends StatefulWidget {
  final String menuId;
  final String brandId;

  EditMenuScreen({required this.menuId, required this.brandId});

  @override
  _EditMenuScreenState createState() => _EditMenuScreenState();
}

class _EditMenuScreenState extends State<EditMenuScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  File? _menuImage;
  final picker = ImagePicker();
  bool isLoading = false;

  // Fetch the current menu details from Firestore
  Future<void> _fetchMenuDetails() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('brands')
          .doc(widget.brandId)
          .collection('menus')
          .doc(widget.menuId)
          .get();
      var menu = snapshot.data() as Map<String, dynamic>;
      nameController.text = menu['name'] ?? '';
      priceController.text = menu['price']?.toString() ?? '';
      descriptionController.text = menu['description'] ?? '';
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error fetching menu: $e')));
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchMenuDetails();
  }

  // Pick image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _menuImage = File(pickedFile.path);
      }
    });
  }

  // Update the menu details
  Future<void> _updateMenu() async {
    if (nameController.text.isEmpty || priceController.text.isEmpty || descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all fields')));
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      String? imageUrl;
      if (_menuImage != null) {
        // Upload new image to Firebase Storage
        final storageRef = FirebaseStorage.instance.ref().child('menu_images').child('${DateTime.now()}.jpg');
        await storageRef.putFile(_menuImage!);
        imageUrl = await storageRef.getDownloadURL();
      }

      // Update menu details in Firestore
      await FirebaseFirestore.instance.collection('brands')
          .doc(widget.brandId)
          .collection('menus')
          .doc(widget.menuId)
          .update({
        'name': nameController.text,
        'price': priceController.text,
        'description': descriptionController.text,
        'imageUrl': imageUrl ?? '',  // If no new image, keep the old one
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Menu updated successfully')));
      Navigator.pop(context); // Go back to AdminScreen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating menu: $e')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Menu')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 100,
                height: 100,
                color: Colors.grey[300],
                child: _menuImage == null
                    ? Icon(Icons.add_a_photo, color: Colors.grey[700])
                    : Image.file(_menuImage!, fit: BoxFit.cover),
              ),
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nama Menu'),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Harga'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Deskripsi'),
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _updateMenu,
              child: Text('Update Menu'),
            ),
          ],
        ),
      ),
    );
  }
}
