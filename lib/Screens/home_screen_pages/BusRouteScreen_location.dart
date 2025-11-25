import 'package:campus_ride/Screens/home_screen_pages/location.dart';
import 'package:flutter/material.dart';

class BusRouteScreen extends StatelessWidget {
  const BusRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bus Route")),
      endDrawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Image.asset("assets/images/logo(2).png"),
            ),
            const Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Text(
                "Campus Contact",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black),
              ),
            ),
            ExpansionTile(
              title: const Text("Location"),
              leading: const Icon(
                Icons.location_on,
                color: Colors.red,
              ),
              childrenPadding: const EdgeInsets.only(left: 50),
              children: [
                ListTile(
                  title: const Text(
                    "Uka Tarsadia University",
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  onTap: () {},
                ),
              ],
            ),
            ExpansionTile(
              title: const Text("Maa Traveller"),
              leading: const Icon(
                Icons.directions_bus,
                color: Colors.red,
              ),
              childrenPadding: const EdgeInsets.only(left: 50),
              children: [
                ListTile(
                  title: const Text(
                    "+91-93139 81394",
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  onTap: () {},
                ),
                ListTile(
                  title: const Text(
                    "maatravel@gmail.com",
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  onTap: () {},
                ),
              ],
            ),
            ExpansionTile(
              title: const Text("Dolphin Traveller"),
              leading: const Icon(
                Icons.directions_bus_filled_rounded,
                color: Colors.red,
              ),
              childrenPadding: const EdgeInsets.only(left: 50),
              children: [
                ListTile(
                  title: const Text(
                    "+91-93139 81394",
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  onTap: () {},
                ),
                ListTile(
                  title: const Text(
                    "dolphinetravel@gmail.com",
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  onTap: () {},
                ),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 450),
              child: Container(
                height: 1,
                width: double.infinity,
                color: Colors.grey.shade300,
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.directions_bus, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          "Route",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_drop_down, color: Colors.white),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Katargam to Campus",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          "08:30AM",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Campus to Katargam",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          "06:00PM",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/busDetails');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                child: const Text(
                  "View Bus",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 16),
              // map code
              GestureDetector(
                onLongPress: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => const MapScreen()));
                },
                child: const SizedBox(
                  height: 350,
                  width: double.infinity,
                  child: MapScreen(),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.directions_bus, color: Colors.black),
                  const SizedBox(width: 4),
                  const Text("3 Bus available"),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    child: const Text("Tap to Track"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
