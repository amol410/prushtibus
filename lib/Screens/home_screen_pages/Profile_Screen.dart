import 'dart:io';
import 'package:campus_ride/Authentication/Login_Screen.dart';
import 'package:campus_ride/Screens/Profile.dart';
import 'package:campus_ride/Screens/feesstructure.dart';
import 'package:campus_ride/Screens/home_screen_pages/Fees_Payment.dart';
import 'package:campus_ride/Screens/settingpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String? userName;
  String? profileImageUrl; // To store the profile image URL

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  // Fetch User Data from Firestore
  void fetchUserProfile() async {
    final user = auth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      if (snapshot.exists && snapshot.data() != null) {
        setState(() {
          userName = snapshot['name'];
          profileImageUrl = snapshot['profileImageUrl']; // Fetch stored profile image URL
        });
      }
    }
  }

  // Pick Image and Upload to Firebase Storage
  Future<void> uploadProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    File imageFile = File(pickedFile.path);
    String userId = auth.currentUser!.uid;
    String filePath = 'profile_images/$userId.jpg';

    try {
      UploadTask uploadTask =
      FirebaseStorage.instance.ref(filePath).putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'profileImageUrl': downloadUrl});

      setState(() {
        profileImageUrl = downloadUrl;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Profile image updated!")));
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  // Logout function
  void _logout() {
    auth.signOut().then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Login_Screen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userName == null
          ? const Center(child: CircularProgressIndicator())
          : Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: uploadProfileImage, // Upload image on tap
                child: CircleAvatar(
                  radius: 75,
                  backgroundImage: profileImageUrl != null
                      ? NetworkImage(profileImageUrl!)
                      : const AssetImage('assets/images/user.png') as ImageProvider,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                userName!,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Your Profile'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Profile()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const SettingPage()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.money),
                title: const Text('Fees Structure'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const FeesStructure()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.bus_alert),
                title: const Text('Bus Pass'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to Bus Pass screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.payment),
                title: const Text('Pay Fees'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PaymentOptionsPage()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Log Out'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: _logout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
