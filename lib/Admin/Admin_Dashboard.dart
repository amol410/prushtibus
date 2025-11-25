import 'package:campus_ride/Admin/Admin_card.dart';
import 'package:campus_ride/Admin/Bus_expense.dart';
import 'package:campus_ride/Admin/Driver_Acc_status.dart';
import 'package:campus_ride/Admin/Handler_Acc_status.dart';
import 'package:campus_ride/Admin/Payment_Status.dart';
import 'package:campus_ride/Admin/Route_Status.dart';
import 'package:campus_ride/Admin/Student_Status.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BusHive',
            style: TextStyle(color: Colors.red, fontStyle: FontStyle.italic,)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: GestureDetector(
                  onTap: () {}, child: const Icon(Icons.person, color: Colors.white)),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            // Students
            DashboardCard(
              title: 'Students',
              subtitle: 'Total Student',
              value: '300',
              icon: Icons.person,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => StudentStatus()));
              },
            ),
            // Payments
            DashboardCard(
              title: 'Payments',
              subtitle: 'Total Payment',
              value: '₹30,000',
              icon: Icons.credit_card,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => PaymentStatus()));
              },
            ),
            // Bus Expense
            DashboardCard(
              title: 'Bus Expense',
              subtitle: 'Total Bus Expense',
              value: '₹23,900',
              icon: Icons.build,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => BusExpenseScreen()));
              },
            ),
            // Buses
            DashboardCard(
              title: 'Buses',
              subtitle: 'Total Buses',
              value: '15',
              icon: Icons.directions_bus,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => StudentStatus()));
              },
            ),
            // Routes
            DashboardCard(
              title: 'Routes',
              subtitle: 'Total Routes',
              value: '15',
              icon: Icons.alt_route,
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => const Bus_Status()));
              },
            ),
            // Handler
            DashboardCard(
              title: 'Handler Account',
              subtitle: 'Total Account',
              value: '5',
              icon: Icons.person_outline_sharp,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const Handler_Acc_status()));
              },
            ),
            // Driver
            DashboardCard(
              title: 'Driver Account',
              subtitle: 'Total Account',
              value: '7',
              icon: Icons.person_outline_sharp,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const Driver_Acc_status()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
