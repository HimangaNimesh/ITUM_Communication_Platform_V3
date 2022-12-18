import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:itum_communication_platform/helper/helper_function.dart';
import 'package:itum_communication_platform/notifications/home_page_notifications.dart';
import 'package:itum_communication_platform/pages/auth/Login_Page.dart';
import 'package:itum_communication_platform/pages/home/profile_page.dart';
import 'package:itum_communication_platform/pages/jobs/jobs_home_page.dart';
import 'package:itum_communication_platform/service/auth_service.dart';
import 'package:itum_communication_platform/service/database_service.dart';
import 'package:itum_communication_platform/widgets/group_tile.dart';
import 'package:itum_communication_platform/widgets/widegets.dart';

import 'search_page.dart';

class GroupHome extends StatefulWidget {
  const GroupHome({Key? key}) : super(key: key);

  @override
  _GroupHomeState createState() => _GroupHomeState();
}

class _GroupHomeState extends State<GroupHome> {
  String userName = "";
  String email = "";
  AuthService authService = AuthService();
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";


  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  String getId(String res){
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res){
    return res.substring(res.indexOf("_")+1);
  }

  gettingUserData()async{
    await HelperFunctions.getUserEmailFromSF().then((value){
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((val){
      setState(() {
        userName = val!;
      });
    });
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getUserGroups().then((snapshot){
      setState(() {
        groups = snapshot;
      });
    });
  }

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
        actions: [
          IconButton(
              onPressed: (){
                nextScreen(context, const SearchPage());
              },
              icon: const Icon(Icons.search, color: Color(0xff649EFF),),),
          IconButton(
            onPressed: (){
              nextScreen(context, const HomeNotifications());
            },
            icon: const Icon(Icons.notifications_none_outlined, color: Color(0xff649EFF),),),
        ],
        title: const Text("Groups",
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
              onTap: (){},
              selectedColor: const Color(0xff649EFF),
              selected: true,
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
              onTap: (){
                nextScreen(context,  JobsHomePage());
              },
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
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          popUpDialog(context);
        },
        backgroundColor: const Color(0xffE5F9FF),
        child: const Icon(Icons.add, color: Color(0xff649EFF),size: 30,),
      ),
    );
  }
  popUpDialog(BuildContext context){
    showDialog(
      barrierDismissible: true,
        context: context,
        builder: (context){
          return StatefulBuilder(
            builder: ((context, setState){
            return AlertDialog(
              title: const Text('Create a group', textAlign: TextAlign.left,),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isLoading == true ? Center(child: CircularProgressIndicator())
                      : TextField(
                    onChanged: (val){
                      setState(() {
                        groupName = val;
                      });
                    },
                    style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Color(0xff649EFF)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xff649EFF)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        ),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                    onPressed: () async{
                      if(groupName!=""){
                        setState(() {
                          _isLoading = true;
                        });
                        DatabaseService(uid:
                        FirebaseAuth.instance.currentUser!.uid).createGroup(
                            userName, FirebaseAuth.instance.currentUser!.uid, groupName).whenComplete((){
                              _isLoading = false;
                        });
                        Navigator.of(context).pop();
                        showSnackBar(context, Colors.greenAccent, "Group created Successfully");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor
                    ),
                    child: Text('CREATE'),
                ),
                ElevatedButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor
                  ),
                  child: Text('CANCEL'),
                ),
              ],
            );})
          );
        });
  }

  groupList(){
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot){
        if(snapshot.hasData){
          if(snapshot.data['groups'] !=null){
            if(snapshot.data['groups'].length !=0){
              return ListView.builder(
                itemCount: snapshot.data['groups'].length,
                itemBuilder: (context, index){
                  int reversIndex = snapshot.data['groups'].length - index - 1;
                  return GroupTile(
                      groupId: getId(snapshot.data['groups'][reversIndex]),
                      groupName: getName(snapshot.data['groups'][reversIndex]),
                      userName: snapshot.data['fullName']
                  );
                },
              );
            }
            else{
              return noGroupWidget();
            }
          }
          else{
            return noGroupWidget();
          }
        }
        else{
          return const Center(child: CircularProgressIndicator(),);
        }
      },
    );
  }
  noGroupWidget(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
              popUpDialog(context);
            },
              child: Icon(Icons.add_circle, color: Colors.grey[700], size: 70,),
          ),
          const SizedBox(height: 20,),
          const Text('You have not joined any groups, tap on the add icon to create a group or also search from top search button.',
          textAlign: TextAlign.center,),
        ],
      ),
    );
  }
}
