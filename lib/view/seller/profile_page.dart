// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:furniy_ar/view/authentication/signin_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import '../../utils/constants.dart';
import '../../widgets/profile_widget.dart';
import '../../controller/authenticationController.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:url_launcher/url_launcher.dart';
import 'package:store_redirect/store_redirect.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  void _loadProfileImage() async {
    final user = AuthController().getCurrentUser();
    if (user != null) {
      var userData = await FirebaseFirestore.instance
          .collection('userProfiles')
          .doc(user.uid)
          .get();
      setState(() {
        _profileImageUrl = userData['profileImage'];
      });
    }
  }

  Future<void> _selectAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('userProfiles')
          .child(fileName);

      await ref.putFile(imageFile);

      String imageUrl = await ref.getDownloadURL();
      final user = AuthController().getCurrentUser();

      await FirebaseFirestore.instance
          .collection('userProfiles')
          .doc(user!.uid)
          .update({'profileImage': imageUrl});

      setState(() {
        _profileImageUrl = imageUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // Get the current user
    final user = AuthController().getCurrentUser();
    // Future<void> _launchURL(String url) async {
    //   if (await canLaunch(url)) {
    //     await launch(url);
    //   } else {
    //     throw 'Could not launch $url';
    //   }
    // }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          height: size.height,
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _selectAndUploadImage,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Constants.primaryColor.withOpacity(.5),
                          width: 5.0,
                        ),
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: _profileImageUrl != null
                                ? NetworkImage(_profileImageUrl!)
                                : const AssetImage('assets/images/profile.jpg')
                                    as ImageProvider<Object>?,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: -5,
                      bottom: 10,
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Constants.whiteColor,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          size: 35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: size.width * .3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      // Use user name from your authentication service
                      user?.displayName ?? 'John Doe',
                      style: TextStyle(
                        color: Constants.blackColor,
                        fontSize: 20,
                      ),
                    ),
                    if (user != null && user.emailVerified)
                      SizedBox(
                        height: 24,
                        child: Image.asset("assets/images/verified.png"),
                      ),
                  ],
                ),
              ),
              Text(
                // Use user email from your authentication service
                user?.email ?? 'johndoe@gmail.com',
                style: TextStyle(
                  color: Constants.blackColor.withOpacity(.3),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: size.height * .7,
                width: size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // const ProfileWidget(
                    //   icon: Icons.person,
                    //   title: 'My Profile',
                    // ),
                    // const ProfileWidget(
                    //   icon: Icons.settings,
                    //   title: 'Settings',
                    // ),
                    // const ProfileWidget(
                    //   icon: Icons.notifications,
                    //   title: 'Notifications',
                    // ),
                    // const ProfileWidget(
                    //   icon: Icons.chat,
                    //   title: 'FAQs',
                    // ),
                    InkWell(
                      onTap: () {
                        // StoreRedirect.redirect(
                        //   androidAppId: "com.sharasol.PKR_Fake_Check_Guide",
                        // );
                        try {
                          Share.share(
                              "https://play.google.com/store/apps/details?id=com.sharasol.PKR_Fake_Check_Guide");
                        } catch (e) {
                          if (kDebugMode) {
                            print(e.toString());
                          }
                        }
                      },
                      child: const ProfileWidget(
                        icon: Icons.share,
                        title: 'Share',
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        try {
                          StoreRedirect.redirect(
                              androidAppId: "com.iyaffle.rangoli",
                              iOSAppId: "585027354");
                        } catch (e) {
                          if (kDebugMode) {
                            print(e);
                          }
                        }
                      },
                      child: const ProfileWidget(
                        icon: Icons.star,
                        title: 'Rate Us',
                      ),
                    ),
                    ProfileWidget(
                      icon: Icons.logout,
                      onPressed: () async {
                        await AuthController().signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignIn(),
                          ),
                        );
                      },
                      title: 'Log Out',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
