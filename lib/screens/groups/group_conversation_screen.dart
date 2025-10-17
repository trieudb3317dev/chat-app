
import 'package:chat_app/screens/groups/group_information_screen.dart';
import 'package:chat_app/screens/groups/group_video_call_screen.dart';
import 'package:flutter/material.dart';

class GroupConversationScreen extends StatefulWidget {
  final Map<String, dynamic> group;

  const GroupConversationScreen({Key? key, required this.group}) : super(key: key);

  @override
  _GroupConversationScreenState createState() => _GroupConversationScreenState();
}

class _GroupConversationScreenState extends State<GroupConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  // Dummy messages for a group
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Does this update fix the error 202 for the Engineer division?',
      'sender': 'Casey',
      'isMe': false,
      'time': '10:10',
      'avatar': 'https://i.pravatar.cc/150?u=casey'
    },
    {'text': 'Great, thanks for letting me know. I really look forward to advancements on this front.🎉', 'sender': 'You', 'isMe': true, 'time': '10:11'},
    {
      'text': 'Oh, they fixed it and I updated! I\'m secretly thrilled. ✨',
      'sender': 'Janet',
      'isMe': false,
      'time': '10:12',
      'avatar': 'https://i.pravatar.cc/150?u=janet'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.group['avatar']!),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.group['name']!, style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                Text('${widget.group['members']} members', style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.videocam_outlined, color: Colors.black),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => GroupVideoCallScreen(group: widget.group),
                ));
              }),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => GroupInformationScreen(group: widget.group),
              ));
            },
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageItem(message);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageItem(Map<String, dynamic> message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: message['isMe'] ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message['isMe'])
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(message['avatar']!),
                radius: 15,
              ),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message['isMe'] ? Colors.blue : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!message['isMe'])
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(message['sender']!, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
                    ),
                  Text(
                    message['text'],
                    style: TextStyle(color: message['isMe'] ? Colors.white : Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.blue),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message ...',
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
