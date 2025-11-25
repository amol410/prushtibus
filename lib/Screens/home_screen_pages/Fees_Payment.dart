import 'package:flutter/material.dart';

class PaymentOptionsPage extends StatelessWidget {
  const PaymentOptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Choose Payment Options",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildPaymentOption(
              "Debit / Credit card ",
              Icons.credit_card,
              Colors.red,
            ),
            _buildPaymentOption(
              "Internet Banking ",
              Icons.account_balance,
              Colors.red,
            ),
            _buildPaymentOption(
              "G Pay ",
              Icons.payment,
              Colors.blue,
            ),
            _buildPaymentOption(
              "Phone Pay ",
              Icons.account_balance_wallet,
              Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String title, IconData icon, Color iconColor) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        height: 67,
        child: Center(
          child: ListTile(
            trailing: Icon(icon, color: iconColor, size: 32),
            title: Text(
              title,
              style: const TextStyle(fontSize: 17),
            ),
            onTap: () {},
          ),
        ),
      ),
    );
  }
}
