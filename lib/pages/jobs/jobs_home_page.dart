import 'package:flutter/material.dart';
import 'package:itum_communication_platform/pages/groups/groups_home_page.dart';
import 'package:itum_communication_platform/service/auth_service.dart';
import 'package:itum_communication_platform/widgets/widegets.dart';

import '../auth/Login_Page.dart';
import '../home/profile_page.dart';

class JobsHomePage extends StatefulWidget {
  const JobsHomePage({Key? key}) : super(key: key);

  @override
  _JobsHomePageState createState() => _JobsHomePageState();
}

class _JobsHomePageState extends State<JobsHomePage> {

  String userName = "";
  String email = "";
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
              onPressed: (){
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu, color: Color(0xff649EFF),)),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xffE5F9FF),
        centerTitle: true,
        title: const Text("Create a Job",
          style: TextStyle(color: Colors.black, fontSize: 27, fontWeight: FontWeight.w600),),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: <Widget>[
            Icon(Icons.account_circle, size: 150, color: Colors.grey[700],),
            const SizedBox(height: 15,),
            Text(userName, textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
            const SizedBox(height: 30,),
            const Divider(height: 2,),
            ListTile(
              onTap: (){
                nextScreen(context,  GroupHome());
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text('Groups', style: TextStyle(color: Colors.black),),
            ),
            ListTile(
              onTap: (){
                nextScreenReplace(context,  ProfilePage(userName: userName,email: email,));
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.person),
              title: const Text('Profile', style: TextStyle(color: Colors.black),),
            ),
            ListTile(
              onTap: (){},
              selectedColor: const Color(0xff649EFF),
              selected: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.work),
              title: const Text('Create Jobs', style: TextStyle(color: Colors.black),),
            ),
            ListTile(
              onTap: ()async{
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context){
                      return AlertDialog(
                        title: Text('LogOut'),
                        content: Text('Are you sure you want to LogOut?'),
                        actions: [
                          IconButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.cancel, color: Colors.red,)),
                          IconButton(
                              onPressed: ()async{
                                await authService.signOut();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (context)=>const LoginPage()),
                                        (route)=>false );
                              },
                              icon: Icon(Icons.done, color: Colors.green,))
                        ],
                      );
                    });

              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.exit_to_app),
              title: const Text('LogOut', style: TextStyle(color: Colors.black),),
            ),
          ],
        ),
      ),
    );
  }
}

