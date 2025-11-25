import 'package:campus_ride/Admin/Admin_Dashboard.dart';
import 'package:campus_ride/Admin/Admin_resister.dart';
import 'package:campus_ride/Authentication/Forget_Screen.dart';
import 'package:campus_ride/Authentication/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Admin_LoginScreen extends StatefulWidget {
  const Admin_LoginScreen({super.key});

  @override
  State<Admin_LoginScreen> createState() => _Admin_LoginScreenState();
}

class _Admin_LoginScreenState extends State<Admin_LoginScreen> {
  String email = "", password = "";

  final _formkey = GlobalKey<FormState>();
  bool _visibility = true;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final FirestoreData _authService = FirestoreData();

  userLogin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email.text, password: _password.text);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => DashboardScreen()));
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
        context, MaterialPageRoute(builder: (_) => const Admin_resister()));
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
              const SizedBox(height: 25),
              Image.asset("assets/images/register.png"),
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

                    // Forgot
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

                    // Login button
                    const SizedBox(height: 10),
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

                    // Don't have an account
                    const SizedBox(height: 30),
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
