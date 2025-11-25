import 'package:flutter/material.dart';

class BusesDetail extends StatelessWidget {
  const BusesDetail({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text('$title Details', style: const TextStyle(fontSize: 24)),
      ),
    );
  }
}
