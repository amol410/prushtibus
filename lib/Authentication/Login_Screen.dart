import 'package:campus_ride/Authentication/Forget_Screen.dart';
import 'package:campus_ride/Authentication/Signup_Screen.dart';
import 'package:campus_ride/Authentication/firebase_auth.dart';
import 'package:campus_ride/Screens/home_screen_pages/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login_Screen extends StatefulWidget {
  const Login_Screen({super.key});

  @override
  State<Login_Screen> createState() => _Login_ScreenState();
}

class _Login_ScreenState extends State<Login_Screen> {
  String email = "", password = "";

  final _formkey = GlobalKey<FormState>();
  bool _visibility = true;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final FirestoreData _authService = FirestoreData();
  bool _isGoogleSignInInProgress = false;

  userLogin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email.text, password: _password.text);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const Home_Screen()));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
          content: Text(
            "Yup!! Login Successful",
            style: TextStyle(fontSize: 20.0, color: Colors.black),
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          "No user found for that email.",
          style: TextStyle(fontSize: 20.0),
        )));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "Wrong Password Provided by User",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        );
      }
    }
  }

  void _signup() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const Sign_up_Screen()));
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Initialize GoogleSignIn
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email'],
      );

      // Sign out first to ensure account picker shows
      await googleSignIn.signOut();

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      // If user cancels the sign-in
      if (googleUser == null) {
        print("Google Sign-In cancelled by user");
        return null;
      }

      print("Google User: ${googleUser.email}");

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      print("Access Token: ${googleAuth.accessToken != null}");
      print("ID Token: ${googleAuth.idToken != null}");

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      print("Firebase User: ${userCredential.user?.email}");

      // Create user document in Firestore if it doesn't exist
      final user = userCredential.user;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (!userDoc.exists) {
          print("Creating new user document for ${user.email}");
          // Create new user document for Google Sign-In users
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'uid': user.uid,
            'name': user.displayName ?? 'User',
            'email': user.email ?? '',
            'profileImageUrl': user.photoURL,
            'timestamp': FieldValue.serverTimestamp(),
          });
          print("User document created successfully");
        } else {
          print("User document already exists");
        }
      }

      return userCredential;
    } catch (e, stackTrace) {
      print("Error during Google Sign-In: $e");
      print("Stack trace: $stackTrace");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text("Google Sign-In failed: ${e.toString()}"),
          ),
        );
      }
      return null;
    }
  }

  _handleGoogleBtnClick() async {
    if (_isGoogleSignInInProgress) return;

    setState(() {
      _isGoogleSignInInProgress = true;
    });

    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Wait a bit for Firebase auth state to update
      await Future.delayed(const Duration(milliseconds: 500));

      final userCredential = await signInWithGoogle();

      // Wait for Firebase to fully process the sign-in
      await Future.delayed(const Duration(milliseconds: 1000));

      // Close loading indicator
      if (mounted) {
        Navigator.pop(context);
      }

      // Check if user is actually signed in to Firebase (even if GoogleSignIn threw an error)
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null && mounted) {
        // Ensure user document exists
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();

        if (!userDoc.exists) {
          print("Creating user document for ${currentUser.email}");
          await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).set({
            'uid': currentUser.uid,
            'name': currentUser.displayName ?? 'User',
            'email': currentUser.email ?? '',
            'profileImageUrl': currentUser.photoURL,
            'timestamp': FieldValue.serverTimestamp(),
          });
        }

        // User is signed in, navigate to home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home_Screen()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
            content: Text(
              "Google Sign-In Successful!",
              style: TextStyle(fontSize: 20.0, color: Colors.black),
            ),
          ),
        );
      } else if (userCredential == null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.orange,
            content: Text("Sign-In was cancelled"),
          ),
        );
      }
    } catch (e) {
      print("Error in Google Sign-In handler: $e");

      // Close loading indicator if still showing
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      // Wait a bit for Firebase to process
      await Future.delayed(const Duration(milliseconds: 1000));

      // Check if user is actually signed in despite the error
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null && mounted) {
        // Ensure user document exists
        try {
          final userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();

          if (!userDoc.exists) {
            print("Creating user document for ${currentUser.email}");
            await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).set({
              'uid': currentUser.uid,
              'name': currentUser.displayName ?? 'User',
              'email': currentUser.email ?? '',
              'profileImageUrl': currentUser.photoURL,
              'timestamp': FieldValue.serverTimestamp(),
            });
          }
        } catch (firestoreError) {
          print("Error creating user document: $firestoreError");
        }

        // User is signed in, navigate to home despite the error
        print("User is signed in despite error, proceeding to home screen");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home_Screen()),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text("Sign-In Error: ${e.toString()}"),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGoogleSignInInProgress = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Image.asset("assets/images/img(3).png"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 25),
                    // Sign-in text
                    const Center(
                      child: Text(
                        "Sign In To Your Account",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Enter email
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _email,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.mail, color: Colors.red),
                        hintText: "Enter Your Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Enter password
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: _password,
                      obscureText: _visibility,
                      decoration: InputDecoration(
                        prefixIcon:
                            const Icon(Icons.password, color: Colors.red),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _visibility
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            setState(() {
                              _visibility = !_visibility;
                            });
                          },
                        ),
                        hintText: "Enter Your Password",
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),

                    // Checkbox remember and forgot
                    Row(
                      children: [
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const Forgot_screen()));
                          },
                          child: const Text(
                            "Forgot Password ?",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Login button
                    GestureDetector(
                      onTap: () {
                        if (_formkey.currentState!.validate()) {
                          setState(() {
                            email = _email.text;
                            password = _password.text;
                          });
                        }
                        userLogin();
                      },
                      child: Container(
                        height: 55,
                        width: 395,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.red,
                        ),
                        child: const Center(
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Or continue with
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                              flex: 2,
                              child: Container(
                                height: 1,
                                color: Colors.grey,
                              )),
                          const Expanded(
                            flex: 3,
                            child: Center(
                              child: Text(
                                "or continue with",
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 1,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Icon Google, Facebook & Twitter
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 55,
                          width: 100,
                          child: TextButton(
                            onPressed: () {
                              _handleGoogleBtnClick();
                            },
                            child: Image.asset('assets/images/google.png'),
                          ),
                        ),
                        SizedBox(
                          height: 55,
                          width: 100,
                          child: TextButton(
                            onPressed: () {},
                            child: Image.asset('assets/images/facebook.png'),
                          ),
                        ),
                        SizedBox(
                          height: 60,
                          width: 100,
                          child: TextButton(
                            onPressed: () {},
                            child: Image.asset('assets/images/twitter.png'),
                          ),
                        ),
                      ],
                    ),

                    // Don't have an account
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account ?",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                        GestureDetector(
                          onTap: _signup,
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                                color: Colors.red),
                          ),
                        )
                      ],
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
