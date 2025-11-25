import 'package:campus_ride/Admin/Admin_Dashboard.dart';
import 'package:campus_ride/Admin/Admin_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Admin_SplashScrean extends StatefulWidget {

  const Admin_SplashScrean({super.key});

  @override
  State<Admin_SplashScrean> createState() => _Admin_SplashScreanState();
}

class _Admin_SplashScreanState extends State<Admin_SplashScrean> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), (){
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashboardScreen()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Admin_LoginScreen()));
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
