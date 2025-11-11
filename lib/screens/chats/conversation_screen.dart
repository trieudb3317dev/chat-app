import 'package:chat_app/providers/conversation_provider.dart';
import 'package:chat_app/screens/chats/user_information_screen.dart';
import 'package:chat_app/screens/chats/video_call_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConversationScreen extends StatelessWidget {
  final Map<String, dynamic> user;

  const ConversationScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId = user['id'] as int? ?? 0;

    return ChangeNotifierProvider(
      create: (_) => ConversationProvider()..fetchMessages(userId),
      child: _ConversationView(user: user, userId: userId),
    );
  }
}

class _ConversationView extends StatefulWidget {
  final Map<String, dynamic> user;
  final int userId;

  const _ConversationView({required this.user, required this.userId});

  @override
  __ConversationViewState createState() => __ConversationViewState();
}

class __ConversationViewState extends State<_ConversationView> {
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
    final provider = Provider.of<ConversationProvider>(context, listen: false);
    // if user scrolled to top (minScrollExtent) load older messages
    if (_scrollController.hasClients &&
        _scrollController.position.pixels <= _scrollController.position.minScrollExtent + 20 &&
        provider.hasMore &&
        !provider.isLoading) {
      provider.fetchMessages(widget.userId);
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    final provider = Provider.of<ConversationProvider>(context, listen: false);
    provider.sendMessage(widget.userId, _messageController.text.trim());
    _messageController.clear();
  }
  
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

  DateTime _parseMessageTime(Map<String, dynamic> msg) {
    // created_at already contains formatted date and time, e.g.:
    // "created_at": { "date": "2025-11-08", "time": "20:59:07" }
    final created = msg['created_at'];
    if (created is Map) {
      final dateStr = created['date'] as String?;
      final timeStr = created['time'] as String?;
      if (dateStr != null && timeStr != null) {
        // combine into a full ISO-like string
        final combined = '$dateStr ${timeStr.split('.').first}';
        final dt = DateTime.tryParse(combined) ?? DateTime.tryParse(dateStr);
        if (dt != null) return dt;
      } else if (dateStr != null) {
        final dt = DateTime.tryParse(dateStr);
        if (dt != null) return dt;
      }
    }
    // fallback
    return DateTime.now();
  }

  String _formatTimeForMessage(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inDays >= 1) {
      return '${dt.year.toString().padLeft(4,'0')}/${dt.month.toString().padLeft(2,'0')}/${dt.day.toString().padLeft(2,'0')}';
    } else {
      return '${dt.hour.toString().padLeft(2,'0')}:${dt.minute.toString().padLeft(2,'0')}';
    }
  }

  String _dateHeaderLabel(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(dt.year, dt.month, dt.day);
    final diffDays = today.difference(d).inDays;
    if (diffDays == 0) return 'Today';
    if (diffDays == 1) return 'Yesterday';
    return '${d.year.toString().padLeft(4,'0')}/${d.month.toString().padLeft(2,'0')}/${d.day.toString().padLeft(2,'0')}';
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
            child: Consumer<ConversationProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.messages.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.error != null && provider.messages.isEmpty) {
                  return Center(child: Text(provider.error!));
                }

                if (provider.messages.isEmpty && !provider.isLoading) {
                  return const Center(child: Text('No messages'));
                }
                
                // Build grouped items (oldest -> newest), ListView will use reverse:true
                final msgs = List<Map<String, dynamic>>.from(provider.messages);
                msgs.sort((a, b) {
                  final da = _parseMessageTime(a);
                  final db = _parseMessageTime(b);
                  return da.compareTo(db);
                });

                final List<Widget> items = [];
                DateTime? lastDate;
                for (final msg in msgs) {
                  final dt = _parseMessageTime(msg);
                  final dayOnly = DateTime(dt.year, dt.month, dt.day);
                  if (lastDate == null || dayOnly.isAfter(lastDate)) {
                    // insert header
                    items.add(
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(_dateHeaderLabel(dt), style: const TextStyle(fontSize: 12, color: Colors.black54)),
                          ),
                        ),
                      ),
                    );
                    lastDate = dayOnly;
                  }

                  final isMe = msg['isMe'] as bool? ?? false;
                  // Row with optional avatar (receiver only) placed outside the message bubble
                  items.add(
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (!isMe) ...[
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: CircleAvatar(
                                radius: 16,
                                backgroundImage: NetworkImage(msg['avatar'] ?? 'https://via.placeholder.com/150'),
                              ),
                            ),
                          ],
                          Container(
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isMe ? Colors.blue : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  msg['text'] ?? '',
                                  style: TextStyle(color: isMe ? Colors.white : Colors.black),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _formatTimeForMessage(dt),
                                  style: TextStyle(color: isMe ? Colors.white70 : Colors.black54, fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (provider.hasMore) {
                  items.insert(0, const Center(child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: CircularProgressIndicator(),
                  )));
                }
  
                return ListView.builder(
                  controller: _scrollController,
                  // do not reverse: keep items oldest -> newest so latest is at the bottom
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return items[index];
                  },
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
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
