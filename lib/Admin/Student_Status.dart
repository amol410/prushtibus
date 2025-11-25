import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentStatus extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  const StudentStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student List")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Student",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No students found", style: TextStyle(fontSize: 18, color: Colors.red)));
                }

                var students = snapshot.data!.docs;

                return ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      var student = students[index].data() as Map<String, dynamic>;

                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ExpansionTile(
                          title: Text(
                            student["name"] ?? "Unknown",
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.red),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Name: ${student["name"] ?? 'N/A'}"),
                                  Text("Enrollment: ${student["enrollment"] ?? 'N/A'}"),
                                  Text("Department: ${student["department"] ?? 'N/A'}"),
                                  Text("Contact no: ${student["phone"] ?? 'N/A'}"),
                                  Text("Route: ${student["route"] ?? 'N/A'}"),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
