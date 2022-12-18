import 'package:flutter/material.dart';
import 'package:itum_communication_platform/widgets/widegets.dart';

class RemindersHome extends StatefulWidget {
  const RemindersHome({Key? key}) : super(key: key);

  @override
  _RemindersHomeState createState() => _RemindersHomeState();
}

class _RemindersHomeState extends State<RemindersHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xff649EFF)),
        title: const Text('Reminders', style: TextStyle(color: Color(0xff649EFF)),),
        backgroundColor: const Color(0xffE5F9FF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Add Reminders',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),),
            const SizedBox(height: 20,),
            TextFormField(
                  decoration: textInputDecoration.copyWith(
                    labelText: "Title",
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
