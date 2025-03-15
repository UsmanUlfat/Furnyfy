
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewFurnitureScreen extends StatelessWidget {
  const ViewFurnitureScreen({super.key});

  Future<void> updateCategory(String furnitureId, String newCategory) async {
    await FirebaseFirestore.instance.collection('furniture').doc(furnitureId).update({'category': newCategory});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Furniture'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('furniture').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final furnitures = snapshot.data!.docs;
          return ListView.builder(
            itemCount: furnitures.length,
            itemBuilder: (context, index) {
              final furniture = furnitures[index].data() as Map<String, dynamic>;
              final furnitureId = furnitures[index].id;
              return Container(
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ExpansionTile(
                  childrenPadding: const EdgeInsets.all(16.0),
                  backgroundColor: Colors.green.withOpacity(0.1),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(furniture['name'] ?? 'No Furniture Name'),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.edit),
                        onSelected: (value) async {
                          await updateCategory(furnitureId, value);
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'Indoor',
                            child: Text('Indoor'),
                          ),
                          const PopupMenuItem(
                            value: 'Outdoor',
                            child: Text('Outdoor'),
                          ),
                          const PopupMenuItem(
                            value: 'Garden',
                            child: Text('Garden'),
                          ),
                          const PopupMenuItem(
                            value: 'Supplement',
                            child: Text('Supplement'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(furniture['image_url']),
                  ),
                  children: [
                    const Text(
                      'Furniture Information',
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 50),
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(furniture['image_url']),
                    ),
                    const SizedBox(height: 50),
                    ListTile(
                      leading: const Icon(Icons.description),
                      title: Text('Description: ${furniture['description']}'),
                    ),

                    ListTile(
                      leading: const Icon(Icons.attach_money),
                      title: Text('Price: \$${furniture['price']}'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.production_quantity_limits),
                      title: Text('Quantity: ${furniture['quantity']}'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.straighten),
                      title: Text('Size: ${furniture['size']}'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.thermostat),
                      title: Text('Temperature: ${furniture['temperature']}'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.category),
                      title: Row(
                        children: [
                          const Icon(Icons.category),
                          const SizedBox(width: 8.0),
                          Text('Category: ${furniture['category']}'),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}