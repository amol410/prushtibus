import 'package:campus_ride/Authentication/Signup_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Forgot_screen extends StatefulWidget {
  const Forgot_screen({super.key});

  @override
  State<Forgot_screen> createState() => _Forgot_screenState();
}

class _Forgot_screenState extends State<Forgot_screen> {
  String email = "";
  TextEditingController mailcontroller = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
          content: Text(
        "Password Reset Email has been sent !",
        style: TextStyle(fontSize: 20.0, color: Colors.black),
      )));
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          "No user found for that email.",
          style: TextStyle(fontSize: 20.0),
        )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment:CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 100,),

            //image
            SizedBox(height: 200,width: double.infinity,child: Image.asset("assets/images/img(4).png",fit: BoxFit.fill,)),

            //pass recoevry text
            Container(
              child: const Text(
                "Password Recovery",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10.0),
            //enter email text
            const Text("Enter your Email",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold)),

            //textfield and dont account and signup button
            Expanded(
                child: Form(
                    key: _formkey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        children: [
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Email is empty";
                              }
                              return null;
                            },
                            controller: mailcontroller,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.lock, color: Colors.red),
                              hintText: "Type your Email",
                              border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40.0),
                          GestureDetector(
                            onTap: () {
                              if (_formkey.currentState!.validate()) {
                                setState(() {
                                  email = mailcontroller.text;
                                });
                                resetPassword();
                              }
                            },
                            child: Container(
                              width: 140,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Center(
                                child: Text(
                                  "Send Email",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 50.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an account?",
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.grey)),
                              const SizedBox(width: 5.0),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Sign_up_Screen()));
                                },
                                child: const Text("Sign Up",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w500)),
                              )
                            ],
                          )
                        ],
                      ),
                    ))),
          ],
        ),
      ),
    );
  }
}
