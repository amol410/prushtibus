import 'package:flutter/material.dart';
import 'package:location/location.dart';

class Driver_Location  extends StatefulWidget {
  const Driver_Location ({super.key});

  @override
  State<Driver_Location> createState() => _Driver_LocationState();
}

class _Driver_LocationState extends State<Driver_Location> {
  bool isGpsEnabled = false;
  bool isGpsOn = false;
  Location location = Location();

  void _toggleGps() {
    setState(() {
      isGpsOn = !isGpsOn;
    });

    if (isGpsOn) {
      // Call method to start GPS
      print("GPS Turned ON");
      // Add GPS activation logic here
    } else {
      // Call method to stop GPS
      print("GPS Turned OFF");
      // Add GPS deactivation logic here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Ride'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/img(2).png'),  // Replace with your bus image asset
            const SizedBox(height: 20),
            const Text(
              'Start GPS',
              style: TextStyle(fontSize: 24),
            ),
            Switch(
              value: isGpsOn,
              onChanged: (value) {
                _toggleGps();
              },
              activeThumbColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
