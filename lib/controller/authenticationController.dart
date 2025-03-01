// ignore_for_file: use_build_context_synchronously, constant_identifier_names, file_names
import 'package:furniy_ar/utils/utils.dart';
import 'package:furniy_ar/view/admin/dashboard_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../view/seller/root_page.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signUpWithEmailAndPassword(
      String email, String name, String password, BuildContext context) async {
    try {
      // Create user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.updateDisplayName(name);
      await _firestore
          .collection('userProfiles')
          .doc(userCredential.user?.uid)
          .set({
        'uid': userCredential.user?.uid,
        'email': email,
        'name': name,
        'password': password,
        'userType': "customer",
        'profileImage': ''
      });
      await userCredential.user?.reload();
      Utils.snackBar("SignUp Success", context);
      Navigator.pushReplacement(
          context,
          PageTransition(
              child: const RootPage(), type: PageTransitionType.bottomToTop));
    } catch (e) {
      Utils.errorSnakbar(context, e.toString());
    }
  }

  Future<void> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Check if the user is an admin (you need to implement your own logic)
        UserType response = await _getUserType(userCredential.user!.uid);
        if (response == UserType.Admin) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) =>
                    const DashboardScreen() // Replace with your AdminRootPage widget
                ),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const RootPage(),
            ),
          );
        }
      }
    } catch (e) {
      Utils.errorSnakbar(
        context,
        e.toString(),
      );
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<UserType> _getUserType(String userId) async {
    try {
      DocumentSnapshot userSnapshot =
          await _firestore.collection('userProfiles').doc(userId).get();
      if (userSnapshot.exists) {
        if (kDebugMode) {
          print(".......");
        }
        String userType = userSnapshot.get('userType');
        return userType == 'admin' ? UserType.Admin : UserType.User;
      } else {
        return UserType.None;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error getting user type: $e");
      }
      return UserType.None;
    }
  }

  Future<UserType> isUserLoggedIn() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Check if the user is an admin (you need to implement your own logic)
        return await _getUserType(user.uid);
      }
      return UserType.None;
    } catch (e) {
      if (kDebugMode) {
        print("Error checking user login status: $e");
      }
      return UserType.None;
    }
  }
}

enum UserType { User, Admin, None }
