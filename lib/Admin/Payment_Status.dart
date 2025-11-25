import 'package:flutter/material.dart';

class PaymentStatus extends StatefulWidget {
  const PaymentStatus({super.key});

  @override
  State<PaymentStatus> createState() => _PaymentStatusState();
}


class _PaymentStatusState extends State<PaymentStatus> {
  String selectedValue = "Payment List";
  List<String> paymentOptions = ["1 Month", "6 Months", "12 Months", "Pending"];
  int paymentAmount = 0;

  void updatePaymentAmount(String selected) {
    setState(() {
      switch (selected) {
        case "1 Month":
          paymentAmount = 2500;
          break;
        case "6 Months":
          paymentAmount = 16000;
          break;
        case "12 Months":
          paymentAmount = 30000;
          break;
        case "Pending":
          paymentAmount = 0;
          break;
        default:
          paymentAmount = 0;
      }
      selectedValue = selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Payment",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "₹$paymentAmount",
              style: const TextStyle(
                fontSize: 24,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedValue == "Payment List" ? null : selectedValue,
                  hint: const Text(
                    "Payment List",
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                  isExpanded: false,
                  icon: const Icon(Icons.arrow_drop_up),
                  items: paymentOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      updatePaymentAmount(newValue);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


