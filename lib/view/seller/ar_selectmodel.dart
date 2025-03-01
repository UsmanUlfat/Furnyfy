import 'package:flutter/material.dart';

import 'ar_model2.dart';
import 'ar_model3.dart';
import 'ar_screen.dart';
class ArSelectmodel extends StatelessWidget {
  final List<Map<String, dynamic>> items = [
    {
      "name": "Old Chair",
      "description": "Comfortable, sturdy, worn, nostalgic, wooden, antique, reliable, timeless, creaky, cherished.",
      "image": "assets/images/one.jpeg",
      "page": ArScreenone()
    },
    {
      "name": "Patio Chair Reconstruction",
      "description": "Repair, refinish, or rebuild patio chairs for improved functionality and appearance.",
      "image": "assets/images/two.jpeg",
      "page": ArScreentwo()
    },
    {
      "name": "The Matrix Chair",
      "description": "Futuristic, ergonomic, high-tech seating inspired by sci-fi aesthetics.",
      "image": "assets/images/threee.jpeg",
      "page": ArScreenthree ()
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AR Models ")),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(items[index]["image"]), // Use AssetImage here
            ),
            title: Text(items[index]["name"]),
            subtitle: Text(items[index]["description"]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => items[index]["page"]),
              );
            },
          );
        },
      ),
    );
  }
}