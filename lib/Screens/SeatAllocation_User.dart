import 'package:flutter/material.dart';

class SeatAllocationScreen extends StatefulWidget {
  const SeatAllocationScreen({super.key});

  @override
  State<SeatAllocationScreen> createState() => _SeatAllocationScreenState();
}

class _SeatAllocationScreenState extends State<SeatAllocationScreen> {
  final int rows = 10;
  final int cols = 10; // Adjusted to match the image (4 seats per row)

  // Example seat allocation: true = filled, false = available
  final List<List<bool>> seatStatus = List.generate(
    10,
    (row) => List.generate(4, (col) => row < 6), // Mark first 6 rows as filled
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Seat Allocation"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Column(children: [
                // Door Label
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text("Door"),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 200),
                  child: Image(
                    image: AssetImage("assets/images/hendle.png"),
                    // Set width
                    height: 70, // Set height
                    fit: BoxFit.cover, // Optional: Adjust how the image fits
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 200),
                  child: Text("Driver"),
                ),
                const SizedBox(height: 20), // Increased spacing

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLegend(Colors.red, "Filled"),
                    const SizedBox(width: 20),
                    _buildLegend(Colors.grey, "Available"),
                  ],
                ),
                const SizedBox(height: 20,),
                // Seat Layout with Driver Icon
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween, // Key change for even spacing
                    children: [
                      // Left Column Seats
                      Expanded(
                          flex: 2, // Added flex for better distribution
                          child:
                              _buildSeatColumn(0, 2)), // Indices for left seats

                      // Driver Icon (Centered)

                      // Right Column Seats
                      Expanded(
                        flex: 3, // Added flex for better distribution
                        child:
                            _buildSeatColumn(1, 4), // Indices for right seats
                      ),
                    ],
                  ),
                ),
                // Increased spacing
                // Legend
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      children: [
        Icon(Icons.event_seat, color: color, size: 25),
        const SizedBox(width: 5),
        Text(label),
      ],
    );
  }

  Widget _buildSeatColumn(int startCol, int endCol) {
    // Added indices
    return Column(
      children: List.generate(rows, (rowIndex) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(endCol - startCol, (colIndex) {
            // Use indices
            bool isFilled =
                seatStatus[rowIndex][startCol + colIndex]; // Use indices
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(
                Icons.event_seat,
                size: 45,
                color: isFilled ? Colors.red : Colors.grey,
              ),
            );
          }),
        );
      }),
    );
  }
}
