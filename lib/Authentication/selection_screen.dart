import 'package:campus_ride/Authentication/Login_Screen.dart';
import 'package:campus_ride/Authentication/Signup_Screen.dart';
import 'package:flutter/material.dart';

class Selection_Screen extends StatefulWidget {
  const Selection_Screen({super.key});

  @override
  State<Selection_Screen> createState() => _Selection_ScreenState();
}

class _Selection_ScreenState extends State<Selection_Screen> {
  signup() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const Sign_up_Screen()));
  }

  login() {
    Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const Login_Screen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset("assets/images/bg.jpg")
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const Sign_up_Screen()));
                },
                child: const SizedBox(
                  height: 50,
                  width: 180,
                  child: Center(child: Text("Registration")),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const Login_Screen()));
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20))
                  ),
                  height: 50,
                  width: 180,
                  child: const Center(child: Text("Login", style: TextStyle(color: Colors.white),)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
