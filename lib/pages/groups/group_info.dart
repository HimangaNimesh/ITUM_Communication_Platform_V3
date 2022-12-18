import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:itum_communication_platform/pages/groups/groups_home_page.dart';
import 'package:itum_communication_platform/service/database_service.dart';
import 'package:itum_communication_platform/widgets/widegets.dart';

class GroupInfo extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String adminName;
  const GroupInfo({Key? key,
    required this.adminName,
    required this.groupName,
    required this.groupId})
      : super(key: key);

  @override
  _GroupInfoState createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? members;
  @override
  void initState() {
    getMembers();
    super.initState();
  }

  getMembers() async{
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMembers(widget.groupId)
        .then((val){
      setState(() {
        members = val;
      });
    });
  }

  String getName(String r){
    return r.substring(r.indexOf("_")+ 1);
  }

  String getId(String res){
    return res.substring(0, res.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xffE5F9FF),
        title: const Text('Group Info', style: TextStyle(color: Colors.black),),
        iconTheme: const IconThemeData(color: Color(0xff649EFF)),
        actions: [
          IconButton(
              onPressed: (){
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context){
                      return AlertDialog(
                        title: Text('Exit'),
                        content: Text('Are you sure you want to Exit the group?'),
                        actions: [
                          IconButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.cancel, color: Colors.red,)),
                          IconButton(
                              onPressed: ()async{
                                DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).toggleGroupJoin(
                                    widget.groupId,
                                    getName(widget.adminName),
                                    widget.groupName).whenComplete((){
                                      nextScreenReplace(context, const GroupHome());
                                });
                              },
                              icon: Icon(Icons.done, color: Colors.green,))
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.exit_to_app,)
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color(0xffE5F9FF).withOpacity(1.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: const Color(0xff649EFF),
                    child: Text(
                      widget.groupName.substring(0,1).toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.white, fontSize: 25
                      ),
                    ),
                  ),
                  const SizedBox(width: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Group: ${widget.groupName}",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 5,),
                      Text(
                        "Admin: ${getName(widget.adminName)}",
                      )
                    ],
                  ),
                ],
              ),
            ),
            memberList(),
          ],
        ),
      ),
    );
  }
  memberList(){
    return StreamBuilder(
      stream: members,
        builder: (context, AsyncSnapshot snapshot){
        if(snapshot.hasData){
          if(snapshot.data['members']!= null){
            if(snapshot.data['members'].length != 0){
              return ListView.builder(
                itemCount: snapshot.data['members'].length,
                  shrinkWrap: true,
                  itemBuilder: (context, index){
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                          backgroundColor: const Color(0xff649EFF),
                        child: Text(
                            getName(snapshot.data['members'][index])
                                .substring(0,1)
                                .toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),),
                      ),
                      title: Text(getName(snapshot.data['members'][index])),
                      subtitle: Text(getId(snapshot.data['members'][index])),
                    ),
                  );
                  });
            }
            else{
              return Center
                (child: Text('NO MEMBERS'),
              );
            }
          }
          else{
            return Center
              (child: Text('NO MEMBERS'),
            );
          }
        }
        else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        });
  }
}
