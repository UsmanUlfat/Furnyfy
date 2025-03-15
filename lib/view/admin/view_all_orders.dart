import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewAllOrders extends StatelessWidget {
  const ViewAllOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Orders'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Order').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final orders = snapshot.data!.docs;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index].data() as Map<String, dynamic>;
              return Container(
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ExpansionTile(
                  childrenPadding: const EdgeInsets.all(16.0),
                  backgroundColor: Colors.green.withOpacity(0.1),
                  title: Text(order['furnitureName'] ?? 'No Furniture Name'),
                  subtitle: Text(order['description'] ?? 'No Description'),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(order['image_url']),
                    radius: 25,
                  ),
                  children: [
                    const Text(
                      ' Furniture Information',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ListTile(
                      title: Text('Furniture ID: ${order['furnitureId']}'),
                    ),

                    ListTile(
                      leading: const Icon(Icons.attach_money),
                      title: Text('Price: \$${order['price']}'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.shopping_cart),
                      title: Text('Quantity: ${order['quantity']}'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.aspect_ratio),
                      title: Text('Size: ${order['size']}'),
                    ),
                    const Text(
                      'User Information',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: Text('User Name: ${order['userName']}'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: Text('User Email: ${order['userEmail']}'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: Text('User Phone: ${order['userPhone']}'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.home),
                      title: Text('User Address: ${order['userAddress']}'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.people),
                      title: Text('User Type: ${order['userType']}'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.access_time),
                      title: Text('Timestamp: ${order['timestamp'].toDate()}'),
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