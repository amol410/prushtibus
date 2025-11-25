import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, String>> notifications = [
    {'message': 'Hey! Live Location of (0459)', 'time': '1 min ago'},
    {
      'message': '2270 has been cancelled due to technical issue',
      'time': '12 min ago'
    },
  ];

  void _clearNotifications() {
    setState(() {
      notifications.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
        actions: [
          TextButton(
            onPressed: _clearNotifications,
            child: const Text(
              'Clear All',
              style: TextStyle(color: Colors.red),
            ),
          )
        ],
      ),
      body: notifications.isEmpty
          ? const Center(child: Text('No notifications'))
          : ListView(
        children: notifications
            .map((notification) => NotificationTile(
          message: notification['message']!,
          time: notification['time']!,
        ))
            .toList(),
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final String message;
  final String time;

  const NotificationTile(
      {required this.message, required this.time, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(CupertinoIcons.bus, color: Colors.red),
        title: Text(message),
        subtitle: Text(time),
      ),
    );
  }
}
