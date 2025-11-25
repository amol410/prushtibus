import 'package:flutter/material.dart';

class FeesStructure extends StatelessWidget {
  const FeesStructure({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, size: 20, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        title: const Text(
          "Fees Structure",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FeeItem(duration: "1 Month", fee: "₹2700"),
            FeeItem(duration: "6 Months", fee: "₹16000"),
            FeeItem(duration: "12 Months", fee: "₹32000"),
          ],
        ),
      ),
    );
  }
}

class FeeItem extends StatelessWidget {
  final String duration;
  final String fee;

  const FeeItem({
    required this.duration,
    required this.fee,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            duration,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            fee,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

