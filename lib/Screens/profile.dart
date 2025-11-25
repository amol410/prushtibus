import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController enrollmentController = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  String selectedGender = "Select"; // Default gender selection
  String selectedTravelAgency = "Select"; // Default travel agency selection
  bool isLoading = true;
  String? profileImageUrl;
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    User? user = auth.currentUser;
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User not logged in!")),
        );
      }
      setState(() => isLoading = false);
      return;
    }

    try {
      DocumentSnapshot userDoc = await firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        setState(() {
          nameController.text = data['name'] ?? "";
          phoneController.text = data['phone'] ?? "";
          emailController.text = data['email'] ?? "";
          departmentController.text = data['department'] ?? "";
          enrollmentController.text = data['enrollment'] ?? "";
          selectedGender = data['gender'] ?? "Select";
          selectedTravelAgency = data['travelAgency'] ?? "Select";
          profileImageUrl = data['profileImageUrl'];
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error loading profile: $e")),
        );
      }
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => selectedImage = File(pickedFile.path));
      uploadImage();
    }
  }

  Future<void> uploadImage() async {
    if (selectedImage == null) return;

    User? user = auth.currentUser;
    if (user == null) return;

    try {
      String filePath = 'profile_images/${user.uid}.jpg';
      UploadTask uploadTask = storage.ref().child(filePath).putFile(selectedImage!);

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      await firestore.collection('users').doc(user.uid).update({'profileImageUrl': downloadUrl});

      setState(() => profileImageUrl = downloadUrl);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile picture updated!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error uploading image: $e")),
      );
    }
  }

  void saveProfileData() async {
    User? user = auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not logged in!")),
      );
      return;
    }

    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        emailController.text.isEmpty ||
        selectedGender == "Select" ||
        selectedTravelAgency == "Select") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields!")),
      );
      return;
    }

    try {
      await firestore.collection('users').doc(user.uid).set({
        'name': nameController.text,
        'phone': phoneController.text,
        'email': emailController.text,
        'department': departmentController.text,
        'enrollment': enrollmentController.text,
        'gender': selectedGender,
        'travelAgency': selectedTravelAgency,
        'profileImageUrl': profileImageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile saved successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving profile: $e")),
      );
    }
  }

  Future<void> logout() async {
    try {
      await auth.signOut();
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error logging out: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Profile", style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: profileImageUrl != null
                      ? NetworkImage(profileImageUrl!)
                      : null,
                  child: profileImageUrl == null
                      ? const Icon(Icons.camera_alt, size: 40, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(height: 16),

              buildTextField("Name", nameController),
              buildTextField("Phone No", phoneController),
              buildTextField("Email", emailController),
              buildTextField("Department", departmentController),
              buildTextField("Enrollment No", enrollmentController),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: DropdownButtonFormField<String>(
                  initialValue: selectedGender,
                  items: ["Select", "Male", "Female", "Other"]
                      .map((gender) => DropdownMenuItem(value: gender, child: Text(gender)))
                      .toList(),
                  decoration: const InputDecoration(
                    labelText: "Gender",
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value!;
                    });
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: DropdownButtonFormField<String>(
                  initialValue: selectedTravelAgency,
                  items: ["Select", "Maa Travels", "Dolphine Travels"]
                      .map((agency) => DropdownMenuItem(value: agency, child: Text(agency)))
                      .toList(),
                  decoration: const InputDecoration(
                    labelText: "Travel Agency",
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedTravelAgency = value!;
                    });
                  },
                ),
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveProfileData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Save", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

}
