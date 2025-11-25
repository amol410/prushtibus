import 'package:campus_ride/Authentication/Login_Screen.dart';
import 'package:campus_ride/Authentication/Signup_Screen.dart';
import 'package:flutter/material.dart';

class Selection_Page extends StatefulWidget {
  const Selection_Page({super.key});

  @override
  State<Selection_Page> createState() => _Selection_PageState();
}

class _Selection_PageState extends State<Selection_Page> {
  void signin() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const Login_Screen()));
  }

  void signup() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const Sign_up_Screen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Image.asset("assets/images/img(1).png"),
              const SizedBox(height: 30,),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 35),
                child: Text("Welcome to Campus Ride, where university transportation meets innovation for a smoother campus journey."),
              ),
              const SizedBox(height: 250),
              Container(
                height: 65,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextButton(
                  onPressed: signin,
                  child: const Text(
                    "Log In",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                height: 65,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextButton(
                  onPressed: signup,
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
