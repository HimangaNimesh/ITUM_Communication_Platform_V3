import 'package:flutter/material.dart';

class PollsViewPage extends StatefulWidget {
  const PollsViewPage({Key? key}) : super(key: key);

  @override
  _PollsViewPageState createState() => _PollsViewPageState();
}

class _PollsViewPageState extends State<PollsViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Created Polls'
        ),
      ),
    );
  }
}
