
import 'package:chat_app/common/group_list_item.dart';
import 'package:chat_app/screens/groups/group_conversation_screen.dart';
import 'package:flutter/material.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({Key? key}) : super(key: key);

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  final List<Map<String, dynamic>> _groupData = [
    {
      "name": "Mahmud Yam",
      "lastMessage": "Please check the last design",
      "avatar": "https://i.pravatar.cc/150?u=mahmudyam",
      "members": 8
    },
    {
      "name": "Group Mobile Experience A-Idol",
      "lastMessage": "Great, thanks to everyone! 🔥",
      "avatar": "https://i.pravatar.cc/150?u=groupmobile",
      "members": 10
    },
    {
      "name": "My charity group ❤️",
      "lastMessage": "Please share to a lot of people for a bigger donation",
      "avatar": "https://i.pravatar.cc/150?u=charitygroup",
      "members": 25
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Groups'),
      ),
      body: ListView.builder(
        itemCount: _groupData.length,
        itemBuilder: (context, index) {
          final group = _groupData[index];
          return GroupListItem(
            name: group['name'],
            lastMessage: group['lastMessage'],
            avatar: CircleAvatar(
              backgroundImage: NetworkImage(group['avatar']!),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => GroupConversationScreen(group: group),
              ));
            },
          );
        },
      ),
    );
  }
}
