// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class OrderScreen extends StatefulWidget {
  final String FurnitureId;
  const OrderScreen({Key? key, required this.FurnitureId}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int quantity = 1;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // Mock plant data
  final Map<String, dynamic> FurnitureData = {
    "description": "This is use for Furniture",
    "image_url": "https://www.google.com/url?sa=i&url=https%3A%2F%2Flovepik.com%2Fimages%2Fpng-furniture.html&psig=AOvVaw2dUh_HLZIH5MOhDmWAXoc-&ust=1722178335944000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCNic186-x4cDFQAAAAAdAAAAABAE",
    "name": "Chair",
    "price": 25,
    "size": "5",
  };

  Future<void> submitOrder() async {
    if (_formKey.currentState!.validate()) {
      final orderData = {
        "FurnitureId": widget.FurnitureId,
        "FurnitureName": FurnitureData["name"],
        "description": FurnitureData["description"],
        "image_url": FurnitureData["image_url"],
        "price": FurnitureData["price"],
        "quantity": quantity,
        "size": FurnitureData["size"],
        "userEmail": _emailController.text,
        "userName": _nameController.text,
        "userPhone": _phoneController.text,
        "userAddress": _addressController.text,
        "userId": "15yahuJpFmRCNYZSVAffGQreZXC2",
        "userType": "customer",
        "timestamp": FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('Order').add(orderData);

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order submitted successfully')),
      );

      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Furniture'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Image.network(FurnitureData["image_url"]),
              Text(
                FurnitureData["name"],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                FurnitureData["description"],
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Size: ${FurnitureData["size"]}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Price: \$${FurnitureData["price"]}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (quantity > 1) quantity--;
                      });
                    },
                    icon: const Icon(Icons.remove),
                  ),
                  Text(quantity.toString()),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        quantity++;
                      });
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: submitOrder,
                child: const Text('Confirm Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
