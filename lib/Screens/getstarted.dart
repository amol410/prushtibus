import 'package:campus_ride/Authentication/Login_Screen.dart';
import 'package:flutter/material.dart';

class getstarted extends StatefulWidget {
  const getstarted({super.key});

  @override
  State<getstarted> createState() => _getstartedState();
}

class _getstartedState extends State<getstarted> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(left: screenWidth *.15, top: screenHeight *.09,child: SizedBox (height: screenHeight *.2, width: screenWidth * .7,child: Image.asset("assets/images/logo(2).png",fit: BoxFit.fill,),),),
          Positioned(left: screenWidth *.15, top: screenHeight *.27,child: SizedBox (height: screenHeight *.2, width: screenWidth * .7,child: Image.asset("assets/images/img(2).png",fit: BoxFit.fill,),),),
          Positioned(top: screenHeight *.49, left: screenWidth *.12,child: const Text("Campus Ride, University ",style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),),),
          Positioned(top: screenHeight *.525, left: screenWidth *.22,child: const Text("bus tracking app",style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),),),
          Positioned(top: screenHeight *.61, left: screenWidth *.05,child: const Text("Getting your day to day bus tracking update is ",style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),),),
          Positioned(top: screenHeight *.63, left: screenWidth *.17,child: const Text("now just a matter of some clicks!",style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),),),
          Positioned(
            top: screenHeight *.75,
            left: screenWidth *.03,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: screenHeight *.06,
                width: screenWidth *.9,
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Login_Screen()));
                  },
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.red),
                  ),
                  child: const Text("Get Started",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
