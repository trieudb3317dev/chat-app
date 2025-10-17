
import 'package:flutter/material.dart';

class InviteFriendsScreen extends StatelessWidget {
  const InviteFriendsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invite Friends'),
      ),
      body: GridView.count(
        crossAxisCount: 4,
        padding: const EdgeInsets.all(16.0),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: const [
          Icon(Icons.facebook, size: 50, color: Colors.blue),
          // Add other social media icons here
        ],
      ),
    );
  }
}
