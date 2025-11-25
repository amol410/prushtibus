import 'package:flutter/material.dart';

class BusPass extends StatefulWidget {
  final Map<String, String> passData;

  const BusPass({super.key, required this.passData});

  @override
  State<BusPass> createState() => _BusPassState();
}

class _BusPassState extends State<BusPass> {
  late Map<String, String> data;

  @override
  void initState() {
    super.initState();
    data = widget.passData; // Assign inside initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.red.shade300),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.directions_bus, size: 50, color: Colors.red),
              const SizedBox(height: 8),
              const Text(
                "MAA / DOLPHIN",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const Divider(color: Colors.red),
              _ticketDetailRow("PASSENGER", "CONTACT NO"),
              _ticketDetailRow("JOHN REDDY", "79599 29567",),
              _ticketDetailRow("VALID FROM", "VALID TILL", "BUS NO"),
              _ticketDetailRow("JAN '24", "JUNE '24", "2001",),
              _ticketDetailRow("FROM", "TO"),
              _ticketDetailRow("SURAT", "UKA TARSADIA UNIVERSITY",),
              const SizedBox(height: 16),

              const SizedBox(height: 8),
              const Text("123 456 789 10 11 12"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ticketDetailRow(String left, String right, [String? third, bool bold = false]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: third == null ? MainAxisAlignment.spaceBetween : MainAxisAlignment.spaceEvenly,
        children: [
          Text(left, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
          if (third == null)
            Text(right, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal))
          else ...[
            Text(right, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
            Text(third, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
          ]
        ],
      ),
    );
  }

}
