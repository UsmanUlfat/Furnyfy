import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewUsersScreen extends StatelessWidget {
  const ViewUsersScreen({super.key});

  Future<void> deleteUser(String userId) async {
    await FirebaseFirestore.instance
        .collection('userProfiles')
        .doc(userId)
        .delete();
  }

  Future<void> restoreUser(Map<String, dynamic> user, String userId) async {
    await FirebaseFirestore.instance
        .collection('userProfiles')
        .doc(userId)
        .set(user);
  }

  Future<void> updateUserType(String userId, String newUserType) async {
    await FirebaseFirestore.instance
        .collection('userProfiles')
        .doc(userId)
        .update({'userType': newUserType});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Users'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('userProfiles').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final users = snapshot.data!.docs;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index].data() as Map<String, dynamic>;
              final userId = users[index].id;

              return Dismissible(
                key: Key(userId),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(
                    size: 40,
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                onDismissed: (direction) async {
                  // Temporarily store the user data
                  final deletedUser = user;
                  final deletedUserId = userId;

                  // Delete the user from the database
                  await deleteUser(deletedUserId);

                  // Show a Snackbar with the "Undo" option
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('User ${deletedUser['name']} deleted'),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () async {
                          // Restore the deleted user if "Undo" is pressed
                          await restoreUser(deletedUser, deletedUserId);
                        },
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: user['profileImage'] != null
                          ? CircleAvatar(
                              radius: 60,
                              backgroundImage:
                                  NetworkImage(user['profileImage']),
                            )
                          : Text(
                              user['name'][0],
                              style: const TextStyle(color: Colors.white),
                            ),
                    ),
                    title: Text(user['name'] ?? 'No Name'),
                    subtitle: Text(user['email'] ?? 'No Email'),
                    childrenPadding: const EdgeInsets.all(16.0),
                    backgroundColor: Colors.green.withOpacity(0.1),
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: Text('Name: ${user['name']}'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.email),
                        title: Text('Email: ${user['email']}'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.perm_identity),
                        title: Text('UID: ${user['uid']}'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.badge),
                        title: Text('User Type: ${user['userType']}'),
                        trailing: PopupMenuButton<String>(
                          icon: const Icon(Icons.edit),
                          onSelected: (value) async {
                            await updateUserType(userId, value);
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'customer',
                              child: Text('Customer'),
                            ),
                            const PopupMenuItem(
                              value: 'admin',
                              child: Text('Admin'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
