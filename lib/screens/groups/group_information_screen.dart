import 'package:flutter/material.dart';

class GroupInformationScreen extends StatefulWidget {
  final Map<String, dynamic> group;

  const GroupInformationScreen({Key? key, required this.group}) : super(key: key);

  @override
  _GroupInformationScreenState createState() => _GroupInformationScreenState();
}

class _GroupInformationScreenState extends State<GroupInformationScreen> {
  bool _muteNotification = false;
  bool _protectedChat = false;
  bool _hideChat = true;
  bool _hideChatHistory = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.videocam_outlined, color: Colors.black), onPressed: () {}),
          IconButton(icon: const Icon(Icons.call_outlined, color: Colors.black), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(widget.group['avatar'] ?? 'https://via.placeholder.com/150'), // FIX: Handle null avatar
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Icon(Icons.edit, color: Colors.white, size: 20),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.group['name'] ?? 'Unknown Group', // FIX: Handle null name
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      IconButton(icon: const Icon(Icons.edit, size: 20, color: Colors.grey), onPressed: () {}),
                    ],
                  ),
                  Text('${widget.group['members']?.length ?? 0} Members', style: const TextStyle(color: Colors.grey, fontSize: 16)), // FIX: Handle null members with ?.length
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('See all members'),
                          Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _buildSection([
              _buildInfoTile('Media, Links & Documents', trailing: '152', onTap: () {}),
            ]),
            const SizedBox(height: 10),
            _buildSection([
              _buildSwitchTile('Mute Notification', _muteNotification, (val) => setState(() => _muteNotification = val)),
              _buildInfoTile('Custom Notification', onTap: () {}),
              _buildSwitchTile('Protected Chat', _protectedChat, (val) => setState(() => _protectedChat = val)),
              _buildSwitchTile('Hide Chat', _hideChat, (val) => setState(() => _hideChat = val)),
              _buildSwitchTile('Hide Chat History', _hideChatHistory, (val) => setState(() => _hideChatHistory = val)),
              _buildInfoTile('Custom Color Chat', trailingWidget: Container(width: 24, height: 24, color: Colors.blue)),
              _buildInfoTile('Custom Background Chat', trailingWidget: Container(width: 24, height: 24, color: Colors.grey.shade300)),
            ]),
            const SizedBox(height: 10),
            _buildSection([
              _buildInfoTile('Report', textColor: Colors.red, onTap: () {}),
              _buildInfoTile('Leave Group', textColor: Colors.red, onTap: () {}),
            ]),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(List<Widget> children) {
    return Container(
      color: Colors.white,
      child: Column(children: children),
    );
  }

  Widget _buildInfoTile(String title, {String? trailing, Color? textColor, VoidCallback? onTap, Widget? trailingWidget}) {
    return ListTile(
      title: Text(title, style: TextStyle(color: textColor)),
      trailing: trailingWidget ?? Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null)
            Text(trailing, style: const TextStyle(color: Colors.grey, fontSize: 16)),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile(String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      secondary: const Icon(Icons.chevron_right, color: Colors.grey), // This is a trick to align with other tiles
    );
  }
}
