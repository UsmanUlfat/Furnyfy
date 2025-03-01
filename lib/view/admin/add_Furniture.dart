import 'dart:io';

import 'package:furniy_ar/utils/app_size.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../controller/adminController.dart';

class AddFurnitureScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _AddFurnitureScreenState createState() => _AddFurnitureScreenState();
}

class _AddFurnitureScreenState extends State<AddFurnitureScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();

  File? _image;
  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        if (kDebugMode) {
          print('No image selected.');
        }
      }
    });
  }

  String? _selectedCategory;
  //category
  final List<String> _categories = ['Indoor', 'Outdoor', 'Supplement'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Furniture'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _image != null
                    ? Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: FileImage(_image!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: pickImage,
                  child: const Text('Pick Image'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: descriptionController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: priceController,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        double.tryParse(value) == null) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: quantityController,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        int.tryParse(value) == null) {
                      return 'Please enter a valid quantity';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                ),
                16.h,
                const SizedBox(height: 16),
                TextFormField(
                  controller: sizeController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter size details';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Size',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_image != null && _formKey.currentState!.validate()) {
                        // Validation passed, proceed with data upload
                        String? imageUrl = await AdminController()
                            .uploadImage(_image!, "Furniture");
                        await AdminController().uploadFurnitureData(
                          name: nameController.text,
                          description: descriptionController.text,
                          price: double.parse(priceController.text),
                          quantity: int.parse(quantityController.text),
                          size: sizeController.text,
                          imageUrl: imageUrl!,
                          category: _selectedCategory!,
                        );
                      } else {
                        // Validation failed or no image selected
                        if (kDebugMode) {
                          print('Please fill in all fields and pick an image.');
                        }
                      }
                    },
                    child: const Text('Upload Data'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
