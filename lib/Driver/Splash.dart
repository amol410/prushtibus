  import 'package:campus_ride/Driver/Driver_Location.dart';
import 'package:campus_ride/Driver/Driver_Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Driver_SplashScrean extends StatefulWidget {

  const Driver_SplashScrean({super.key});

  @override
  State<Driver_SplashScrean> createState() => _Driver_SplashScreanState();
}

class _Driver_SplashScreanState extends State<Driver_SplashScrean> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), (){
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Driver_Location()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Driver_LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset("assets/images/splash.png"),
      ),
    );
  }
}
