import 'package:campus_ride/Admin/Admin_card.dart';
import 'package:flutter/material.dart';

class Driver_Acc_status extends StatefulWidget {
  const Driver_Acc_status({super.key});

  @override
  State<Driver_Acc_status> createState() => _Driver_Acc_statusState();
}

class _Driver_Acc_statusState extends State<Driver_Acc_status> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DashboardCard(
              title: 'Godhani Meet',
              subtitle: 'Chaprabhatha',
              value: '0459',
              icon: Icons.person_outline_sharp,
              onTap: () {
                buildShowDialog(context);
              },
            ),
            DashboardCard(
              title: 'Kartik Tank',
              subtitle: 'Amroli',
              value: '0811',
              icon: Icons.person_outline_sharp,
              onTap: () {
                buildShowDialog(context);
              },
            ),
            DashboardCard(
              title: 'Soham Parmar',
              subtitle: 'Tadvadi',
              value: '1417',
              icon: Icons.person_outline_sharp,
              onTap: () {
                buildShowDialog(context);
              },
            ),
            DashboardCard(
              title: 'Kevin Singala',
              subtitle: 'Kosad',
              value: '9381',
              icon: Icons.person_outline_sharp,
              onTap: () {
                buildShowDialog(context);
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[100],
    );
  }

  Future<dynamic> buildShowDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Dialog Title"),
          content: const Text("This is a simple dialog in Flutter."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
