import 'package:flutter/material.dart';

class Turnon extends StatefulWidget {
  const Turnon({super.key});

  @override
  State<Turnon> createState() => _TurnonState();
}

class _TurnonState extends State<Turnon> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: const BoxDecoration(
              ),
              child: Image.asset("assets/images/img(1).png"),
            ),
            const Text(
              "Please Turnon Your Location",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.black),
            ),
            // SizedBox(height: 15),
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                "If you don't on your location, you will not able to see how far you bus from you",
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
            ),
            //SizedBox(height: 30),
            Container(
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(6)),
              child: const Center(
                child: Text(
                  "Turn On",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}