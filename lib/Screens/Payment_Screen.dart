import 'package:flutter/material.dart';


class DebitCreditCardPage extends StatefulWidget {
  const DebitCreditCardPage({super.key});

  @override
  _DebitCreditCardPageState createState() => _DebitCreditCardPageState();
}

class _DebitCreditCardPageState extends State<DebitCreditCardPage> {
  String selectedTab = 'Debit Card';
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  String selectedMonth = 'Jan';
  String selectedYear = '2025';

  List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  List<String> years = ['2021', '2022', '2023', '2024', '2025', '2026', '2027'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Debit / Credit\nCard',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedTab = 'Debit Card'),
                    child: Column(
                      children: [
                        Text(
                          'Debit Card',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: selectedTab == 'Debit Card'
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ),
                        if (selectedTab == 'Debit Card')
                          Container(
                              height: 2,
                              color: Colors.red,
                              margin: const EdgeInsets.only(top: 4))
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedTab = 'Credit Card'),
                    child: Column(
                      children: [
                        Text(
                          'Credit Card',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: selectedTab == 'Credit Card'
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ),
                        if (selectedTab == 'Credit Card')
                          Container(
                              height: 2,
                              color: Colors.red,
                              margin: const EdgeInsets.only(top: 4))
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Text(
              'Card Number',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: '5534 2834 8857 5370',
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Expiry Date',
                        style: TextStyle(fontSize: 15),
                      ),
                      Row(
                        children: [
                          DropdownButton<String>(
                            value: selectedMonth,
                            items: months.map((month) {
                              return DropdownMenuItem(
                                value: month,
                                child: Text(month),
                              );
                            }).toList(),
                            onChanged: (value) =>
                                setState(() => selectedMonth = value!),
                          ),
                          const SizedBox(width: 10),
                          DropdownButton<String>(
                            value: selectedYear,
                            items: years.map((year) {
                              return DropdownMenuItem(
                                value: year,
                                child: Text(year),
                              );
                            }).toList(),
                            onChanged: (value) =>
                                setState(() => selectedYear = value!),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CVV',
                        style: TextStyle(fontSize: 15),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        obscureText: true,
                        maxLength: 3,
                        decoration: InputDecoration(
                          counterText: '',
                          hintText: '•••',
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Name',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Jignesh Patel',
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Cancel Payment'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Pay Now'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}