import 'package:chat_app/common/conversation_list_item.dart';
import 'package:chat_app/screens/chats/add_friend_screen.dart';
import 'package:chat_app/screens/chats/conversation_screen.dart';
import 'package:chat_app/screens/chats/create_group_screen.dart';
import 'package:flutter/material.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _chatData = [
    {
      "name": "David Wayne",
      "lastMessage": "Thanks a bunch! Have a great day! 😊",
      "time": "10:25",
      "unreadCount": 5,
      "avatar": "https://i.pravatar.cc/150?u=davidwayne",
      "phone": "(+44) 50 9285 3022"
    },
    {
      "name": "Edward Davidson",
      "lastMessage": "Great, thanks so much! 🙏",
      "time": "22:20 09/05",
      "unreadCount": 12,
      "avatar": "https://i.pravatar.cc/150?u=edwarddavidson",
      "phone": "(+44) 50 9285 2091"
    },
    {
      "name": "Angela Kelly",
      "lastMessage": "Appreciate it! See you soon! 🚀",
      "time": "10:45 08/05",
      "unreadCount": 1,
      "avatar": "https://i.pravatar.cc/150?u=angelakelly",
      "phone": "(+44) 50 9285 2092"
    },
    {
      "name": "Jean Dare",
      "lastMessage": "Hooray! 🎉",
      "time": "20:10 05/05",
      "unreadCount": 0,
      "avatar": "https://i.pravatar.cc/150?u=jeandare",
      "phone": "(+44) 50 9285 2093"
    },
    {
      "name": "Dennis Borer",
      "lastMessage": "Your order has been successfully delivered",
      "time": "17:02 05/05",
      "unreadCount": 0,
      "avatar": "https://i.pravatar.cc/150?u=dennisborer",
      "phone": "(+44) 50 9285 2094"
    },
    {
      "name": "Cayla Rath",
      "lastMessage": "See you soon!",
      "time": "11:20 05/05",
      "unreadCount": 0,
      "avatar": "https://i.pravatar.cc/150?u=caylarath",
      "phone": "(+44) 50 9285 2095"
    },
    {
      "name": "Erin Turcotte",
      "lastMessage": "I'm ready to drop off your delivery. 👍",
      "time": "19:35 02/05",
      "unreadCount": 0,
      "avatar": "https://i.pravatar.cc/150?u=erinturcotte",
      "phone": "(+44) 50 9285 2096"
    },
    {
      "name": "Rodolfo Walter",
      "lastMessage": "Appreciate it! Hope you enjoy it!",
      "time": "07:55 01/05",
      "unreadCount": 0,
      "avatar": "https://i.pravatar.cc/150?u=rodolfowalter",
      "phone": "(+44) 50 9285 2097"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.blue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            _buildHeader(),
            _buildChatList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 16, right: 16, bottom: 16),
      color: Colors.blue.shade600,
      child: _isSearching ? _buildSearchBar() : _buildTitleBar(),
    );
  }

  Widget _buildTitleBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'E-Chat',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'Add Friend') {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddFriendScreen()));
                } else if (value == 'Create Group') {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CreateGroupScreen()));
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem<String>(
                    value: 'Add Friend',
                    child: Row(
                      children: [
                        Icon(Icons.person_add_alt_1_outlined, color: Colors.black87),
                        SizedBox(width: 8),
                        Text('Add Friend'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Create Group',
                    child: Row(
                      children: [
                        Icon(Icons.group_add_outlined, color: Colors.black87),
                        SizedBox(width: 8),
                        Text('Create Group'),
                      ],
                    ),
                  ),
                ];
              },
              icon: const Icon(Icons.add, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            setState(() {
              _isSearching = false;
              _searchController.clear();
            });
          },
        ),
      ],
    );
  }

  Widget _buildChatList() {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: ClipRRect(
            borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 10),
            itemCount: _chatData.length,
            itemBuilder: (context, index) {
              final chat = _chatData[index];
              return ConversationListItem(
                name: chat['name'],
                lastMessage: chat['lastMessage'],
                time: chat['time'],
                unreadCount: chat['unreadCount'],
                avatar: CircleAvatar(
                  backgroundImage: NetworkImage(chat['avatar']),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => ConversationScreen(user: chat),
                  ));
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
