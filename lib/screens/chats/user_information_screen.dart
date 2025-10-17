
import 'package:flutter/material.dart';

class UserInformationScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const UserInformationScreen({Key? key, required this.user}) : super(key: key);

  @override
  _UserInformationScreenState createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  bool _muteNotifications = false;
  bool _pinnedChat = true;
  bool _customBgBlur = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              // Show more options
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(widget.user['avatar']!),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.user['name']!,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.user['phone']!,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Media, links & documents'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Navigate to media screen
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Mute Notification'),
                    value: _muteNotifications,
                    onChanged: (value) {
                      setState(() {
                        _muteNotifications = value;
                      });
                    },
                  ),
                  ListTile(
                    title: const Text('Custom Notification'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  ListTile(
                    title: const Text('Pinned Chat'),
                    trailing: Switch(
                      value: _pinnedChat,
                      onChanged: (value) {
                        setState(() {
                          _pinnedChat = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Hide Chat History'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Add to homescreen'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  SwitchListTile(
                    title: const Text('Custom background blur'),
                    value: _customBgBlur,
                    onChanged: (value) {
                      setState(() {
                        _customBgBlur = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Report'),
                    textColor: Colors.red,
                    onTap: () {},
                  ),
                  ListTile(
                    title: const Text('Block'),
                    textColor: Colors.red,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
