// ignore_for_file: file_names

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AdminController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  User? get currentUser => _auth.currentUser;



  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      if (kDebugMode) {
        print('Error signing in: $e');
      }
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String?> uploadImage(File imageFile, String folderName) async {
    try {
      Reference storageReference = _storage.ref().child('$folderName/${DateTime.now().millisecondsSinceEpoch.toString()}');
      UploadTask uploadTask = storageReference.putFile(imageFile);
      await uploadTask;

      String downloadURL = await storageReference.getDownloadURL();
      return downloadURL;
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading image: $e');
      }
      return null;
    }
  }

  Future<void> uploadFurnitureData({
    required String name,
    required String description,
    required double price,
    required int quantity,
    required String size,
    required String imageUrl, required String category,
  }) async {
    try {
      await _firestore.collection('furniture').add({
        'name': name,
        'description': description,
        'price': price,
        'quantity': quantity,
        'size': size,
        'image_url': imageUrl,
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading Furniture data: $e');
      }
    }
  }
}
