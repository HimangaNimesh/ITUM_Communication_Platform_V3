import 'package:flutter/material.dart';

class InboxNotifications extends StatefulWidget {
  const InboxNotifications({Key? key}) : super(key: key);

  @override
  _InboxNotificationsState createState() => _InboxNotificationsState();
}

class _InboxNotificationsState extends State<InboxNotifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
            'Created Reminders'
        ),
      ),
    );;
  }
}
