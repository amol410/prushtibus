import 'dart:async';
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
  bool isUploadingImage = false;
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
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          selectedImage = File(pickedFile.path);
        });

        // Upload the image immediately after selection
        await uploadImage();
      }
    } catch (e) {
      print("Error picking image: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error selecting image: $e")),
        );
      }
    }
  }

  Future<void> uploadImage() async {
    if (selectedImage == null) {
      print("❌ No image selected");
      return;
    }

    User? user = auth.currentUser;
    if (user == null) {
      print("❌ No user logged in");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User not logged in!")),
        );
      }
      return;
    }

    // Show loading state
    setState(() {
      isUploadingImage = true;
    });

    try {
      print("✅ Starting image upload for user: ${user.uid}");
      print("📁 File path: ${selectedImage!.path}");
      print("📊 File size: ${await selectedImage!.length()} bytes");

      // Create a unique file path for the profile image
      String filePath = 'profile_images/${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference storageRef = storage.ref().child(filePath);

      print("🚀 Uploading to Firebase Storage: $filePath");

      // Upload the file to Firebase Storage with metadata
      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'userId': user.uid},
      );

      UploadTask uploadTask = storageRef.putFile(selectedImage!, metadata);

      // Monitor upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress = snapshot.bytesTransferred / snapshot.totalBytes;
        print("📤 Upload progress: ${(progress * 100).toStringAsFixed(2)}%");
      });

      // Add timeout to prevent hanging forever
      TaskSnapshot snapshot = await uploadTask.timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          throw TimeoutException('Upload timed out after 60 seconds');
        },
      );

      print("✅ Upload completed! State: ${snapshot.state}");

      // Get the download URL
      print("🔗 Getting download URL...");
      String downloadUrl = await snapshot.ref.getDownloadURL();
      print("✅ Download URL: $downloadUrl");

      // Update Firestore with the new profile image URL
      print("💾 Updating Firestore...");
      await firestore.collection('users').doc(user.uid).update({
        'profileImageUrl': downloadUrl,
      });
      print("✅ Firestore updated successfully!");

      // Update local state
      if (mounted) {
        setState(() {
          profileImageUrl = downloadUrl;
          isUploadingImage = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profile picture updated successfully!"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on TimeoutException catch (e) {
      print("⏱️ Upload timeout: $e");
      if (mounted) {
        setState(() {
          isUploadingImage = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Upload timed out. Please check your internet connection and try again."),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 5),
          ),
        );
      }
    } on FirebaseException catch (e) {
      print("🔥 Firebase error: ${e.code} - ${e.message}");
      if (mounted) {
        setState(() {
          isUploadingImage = false;
        });

        String errorMessage = "Upload failed: ";
        if (e.code == 'unauthorized') {
          errorMessage += "Permission denied. Please check Firebase Storage rules.";
        } else if (e.code == 'canceled') {
          errorMessage += "Upload was canceled.";
        } else {
          errorMessage += e.message ?? e.code;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      print("❌ Error uploading image: $e");
      print("Stack trace: ${StackTrace.current}");

      if (mounted) {
        setState(() {
          isUploadingImage = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error uploading image: $e"),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> saveProfileData() async {
    User? user = auth.currentUser;
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User not logged in!")),
        );
      }
      return;
    }

    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        emailController.text.isEmpty ||
        selectedGender == "Select" ||
        selectedTravelAgency == "Select") {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill all required fields!")),
        );
      }
      return;
    }

    // Show loading indicator
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      print("💾 Saving profile data for user: ${user.uid}");

      // Use set with merge to avoid overwriting existing fields like 'uid'
      await firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'email': emailController.text.trim(),
        'department': departmentController.text.trim(),
        'enrollment': enrollmentController.text.trim(),
        'gender': selectedGender,
        'travelAgency': selectedTravelAgency,
        'profileImageUrl': profileImageUrl ?? '',
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      print("✅ Profile saved successfully!");

      // Close loading dialog first
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);

        // Wait a frame before showing SnackBar
        await Future.delayed(const Duration(milliseconds: 100));

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Profile saved successfully!"),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      print("❌ Error saving profile: $e");

      // Close loading dialog first
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);

        // Wait a frame before showing SnackBar
        await Future.delayed(const Duration(milliseconds: 100));

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error saving profile: $e"),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
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
                onTap: isUploadingImage ? null : pickImage,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: selectedImage != null
                          ? FileImage(selectedImage!)
                          : (profileImageUrl != null && profileImageUrl!.isNotEmpty
                              ? NetworkImage(profileImageUrl!) as ImageProvider
                              : null),
                      onBackgroundImageError: (exception, stackTrace) {
                        print("❌ Error loading profile image: $exception");
                        // Reset the profile image URL if it fails to load
                        if (mounted) {
                          setState(() {
                            profileImageUrl = null;
                          });
                        }
                      },
                      child: profileImageUrl == null && selectedImage == null
                          ? const Icon(Icons.camera_alt, size: 40, color: Colors.white)
                          : null,
                    ),
                    if (isUploadingImage)
                      Positioned.fill(
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.black54,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Tap to change profile picture",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
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
