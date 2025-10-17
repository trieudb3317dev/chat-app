import 'package:chat_app/screens/chats/user_information_screen.dart';
import 'package:chat_app/screens/chats/video_call_screen.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const ConversationScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  // Dummy messages
  final List<Map<String, dynamic>> _messages = [
    {'text': 'Speedy Chow. I\'m just around the corner from your place. 😎', 'isMe': false, 'time': '10:10'},
    {'text': 'Hi!', 'isMe': true, 'time': '10:10'},
    {'text': 'Awesome, thanks for letting me know! Can\'t wait for my delivery. 🚚', 'isMe': true, 'time': '10:11'},
    {'text': 'No problem at all!\nI\'ll be there in about 15 minutes.', 'isMe': false, 'time': '10:11'},
    {'text': 'I\'ll text you when I arrive.', 'isMe': false, 'time': '10:11'},
    {'text': 'Great! 👍', 'isMe': true, 'time': '10:12'},
  ];

  void _showAttachmentMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            children: [
              _buildAttachmentOption(Icons.camera_alt, 'Camera'),
              _buildAttachmentOption(Icons.mic, 'Record'),
              _buildAttachmentOption(Icons.contact_page, 'Contact'),
              _buildAttachmentOption(Icons.photo_library, 'Gallery'),
              _buildAttachmentOption(Icons.location_on, 'My Location'),
              _buildAttachmentOption(Icons.insert_drive_file, 'Document'),
            ],
          ),
        );
      },
    );
  }

  void _showMoreOptions() {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 100, 0, 0),
      items: [
        const PopupMenuItem<String>(
          value: 'Search',
          child: Text('Search'),
        ),
        const PopupMenuItem<String>(
          value: 'Mute Notifications',
          child: Text('Mute Notifications'),
        ),
        const PopupMenuItem<String>(
          value: 'Wallpaper',
          child: Text('Wallpaper'),
        ),
        const PopupMenuItem<String>(
          value: 'Clear History',
          child: Text('Clear History'),
        ),
        const PopupMenuItem<String>(
          value: 'Block',
          child: Text('Block'),
        ),
      ],
    );
  }

  Widget _buildAttachmentOption(IconData icon, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 30, color: Colors.blue),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => UserInformationScreen(user: widget.user),
            ));
          },
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.user['avatar']!),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.user['name']!, style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(widget.user['phone'] ?? '', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam_outlined, color: Colors.black),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => VideoCallScreen(user: widget.user),
              ));
            },
          ),
          IconButton(icon: const Icon(Icons.call_outlined, color: Colors.black), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert, color: Colors.black), onPressed: _showMoreOptions),
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
                return Align(
                  alignment: message['isMe'] ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: message['isMe'] ? Colors.blue : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          message['text'],
                          style: TextStyle(color: message['isMe'] ? Colors.white : Colors.black),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          message['time'],
                          style: TextStyle(color: message['isMe'] ? Colors.white70 : Colors.black54, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.blue),
                  onPressed: _showAttachmentMenu,
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
                  onPressed: () {
                    // Send message logic
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
