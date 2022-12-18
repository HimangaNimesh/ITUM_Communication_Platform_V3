import 'package:flutter/material.dart';

class HomeNotifications extends StatefulWidget {
  const HomeNotifications({Key? key}) : super(key: key);

  @override
  _HomeNotificationsState createState() => _HomeNotificationsState();
}

class _HomeNotificationsState extends State<HomeNotifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Home Notifications'),
      ),
    );
  }
}
