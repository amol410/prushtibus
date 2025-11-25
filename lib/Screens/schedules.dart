import 'package:flutter/material.dart';

class Schedules extends StatefulWidget {
  const Schedules({super.key});

  @override
  State<Schedules> createState() => _SchedulesState();
}

class _SchedulesState extends State<Schedules> {
  // Define the list of dropdown items and the selected value
  List<String> area = ['Area 1', 'Area 2', 'Area 3', 'Area 4'];
  String? dropdownValue; // This will hold the selected value

  @override
  void initState() {
    super.initState();
    dropdownValue = area.isNotEmpty ? area[0] : null; // Initialize with the first item or null
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Container(color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: DropdownButton<String>(
                            value: dropdownValue,
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue = newValue;
                              });
                            },
                            items: area.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            isExpanded: true,
                            hint: const Text('Select Area'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
