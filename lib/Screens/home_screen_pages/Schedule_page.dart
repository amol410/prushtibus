import 'package:campus_ride/Screens/SeatAllocation_User.dart';
import 'package:flutter/material.dart';

class Schedule_Screen extends StatelessWidget {
  const Schedule_Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bus Schedule")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "26 Sep 2024",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      "Route",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SeatAllocationScreen()));
                    },
                    child: _buildRouteSection(
                      "Katargam to Campus",
                      [
                        {"name": "Shankeshwar", "code": "Bus No: 0459"},
                        {"name": "Maa Travel - 1", "code": "Bus No: 2270"},
                        {"name": "Maa Travel - 2", "code": "Bus No: 9375"},
                      ],
                    ),
                  ),
                  const Divider(),
                  _buildRouteSection(
                    "Campus to Katargam",
                    [
                      {"name": "Shankeshwar", "code": "Bus No: 0459"},
                      {"name": "Maa Travel - 1", "code": "Bus No: 2270"},
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteSection(String title, List<Map<String, String>> stops) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 8),
        ...stops.map((stop) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(stop["name"] ?? ""),
                  Text(stop["code"] ?? ""),
                ],
              ),
            )),
      ],
    );
  }
}
