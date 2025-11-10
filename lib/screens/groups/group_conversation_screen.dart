import 'package:chat_app/providers/group_conversation_provider.dart';
import 'package:chat_app/screens/groups/group_information_screen.dart';
import 'package:chat_app/screens/groups/group_video_call_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupConversationScreen extends StatelessWidget {
  final Map<String, dynamic> group;

  const GroupConversationScreen({Key? key, required this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groupId = group['id'] as int? ?? 0;

    return ChangeNotifierProvider(
      create: (_) => GroupConversationProvider()..fetchMessages(groupId, isRefresh: true),
      child: _GroupConversationView(group: group, groupId: groupId),
    );
  }
}

class _GroupConversationView extends StatefulWidget {
  final Map<String, dynamic> group;
  final int groupId;

  const _GroupConversationView({required this.group, required this.groupId});

  @override
  __GroupConversationViewState createState() => __GroupConversationViewState();
}

class __GroupConversationViewState extends State<_GroupConversationView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final provider = Provider.of<GroupConversationProvider>(context, listen: false);
    // Load more when reaching the top of the list (since it's reversed)
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
        provider.hasMore &&
        !provider.isLoading) {
      provider.fetchMessages(widget.groupId);
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    final provider = Provider.of<GroupConversationProvider>(context, listen: false);
    provider.sendMessage(widget.groupId, _messageController.text.trim());
    _messageController.clear();
  }

  Widget _buildTimestamp(Map<String, dynamic> createdAt) {
    final String date = createdAt['date'] ?? '';
    final String time = createdAt['time'] ?? '';
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Text(
          '$date $time', 
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ),
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
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.group['avatar'] ?? 'https://via.placeholder.com/150'),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.group['name'] ?? 'Unknown Group', style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                Text('${widget.group['members']?.length ?? 0} members', style: const TextStyle(color: Colors.grey, fontSize: 12)),
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
            child: Consumer<GroupConversationProvider>(
               builder: (context, provider, child) {
                if (provider.isLoading && provider.messages.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.error != null && provider.messages.isEmpty) {
                  return Center(child: Text(provider.error!));
                }
                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.messages.length + (provider.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                     if (index == provider.messages.length && provider.hasMore) {
                      return const Center(child: Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()));
                    }

                    final currentMessage = provider.messages[index];
                    bool showTimestampHeader = false;

                    // Logic to show timestamp header
                    if (index >= provider.messages.length - 1) {
                      showTimestampHeader = true; // Always show for the oldest message
                    } else {
                      final previousMessage = provider.messages[index + 1];
                      if (currentMessage['sender']?['id'] != previousMessage['sender']?['id']) {
                        showTimestampHeader = true;
                      } else {
                        try {
                          final time1 = DateTime.parse("${currentMessage['created_at']?['date']} ${currentMessage['created_at']?['time']}");
                          final time2 = DateTime.parse("${previousMessage['created_at']?['date']} ${previousMessage['created_at']?['time']}");
                          if (time1.difference(time2).inMinutes > 5) {
                            showTimestampHeader = true;
                          }
                        } catch (e) {
                          showTimestampHeader = true; // Fallback in case of parsing error
                        }
                      }
                    }

                    return Column(
                      children: [
                        if (showTimestampHeader) _buildTimestamp(currentMessage['created_at']),
                        _buildMessageItem(currentMessage),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageItem(Map<String, dynamic> message) {
    final isMe = message['isMe'] as bool? ?? false;
    final sender = message['sender'] as Map<String, dynamic>? ?? {};

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(sender['avatar'] ?? 'https://via.placeholder.com/150'),
                radius: 15,
              ),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isMe ? Colors.blue : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (!isMe)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(sender['name'] ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
                    ),
                  Text(
                    message['text'] ?? '',
                    style: TextStyle(color: isMe ? Colors.white : Colors.black),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message['created_at']?['time'] ?? '',
                    style: TextStyle(color: isMe ? Colors.white70 : Colors.black54, fontSize: 10),
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
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
