import 'package:flutter/material.dart';
import 'package:itum_communication_platform/widgets/widegets.dart';

import '../pages/groups/chat_page.dart';

class GroupTile extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;
  const GroupTile({Key? key,
    required this.groupId,
    required this.groupName,
    required this.userName}
      ) : super(key: key);

  @override
  _GroupTileState createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        nextScreen(context, ChatPage(
          groupId: widget.groupId,
          groupName: widget.groupName,
          userName: widget.userName,

        ));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 0.2,
              blurRadius: 5,
              offset: const Offset(0.0, 5.0)
            )
          ]
        ),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        padding: const EdgeInsets.symmetric(vertical: 5,),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Color(0xff649EFF),
            child: Text(
              widget.groupName.substring(0,1).toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500
              ),
            ),
          ),
          title: Text(
            widget.groupName,style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text('Join the conversation as ${widget.userName}',style: TextStyle(fontSize: 13),),
        ),
      ),
    );
  }
}
