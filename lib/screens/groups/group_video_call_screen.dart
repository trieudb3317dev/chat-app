import 'package:flutter/material.dart';

class GroupVideoCallScreen extends StatelessWidget {
  final Map<String, dynamic> group;

  const GroupVideoCallScreen({Key? key, required this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ** THE FIX IS HERE **
    // 1. Safely get the list of members.
    final List<dynamic> members = group['members'] ?? [];
    // 2. Map the members list to a list of avatar URLs.
    final List<String> participants = members.map((member) {
      final user = member['user'] ?? {};
      // Use the real avatar if available, otherwise a placeholder
      return user['avatar'] as String? ?? 'https://i.pravatar.cc/150?u=user${user['id'] ?? 'unknown'}';
    }).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              // Also handle null group name safely
              title: Text('Calling ${group['name'] ?? 'Group'}...', style: const TextStyle(color: Colors.white)),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: participants.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(participants[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
            _buildControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.mic_off, color: Colors.white, size: 30),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.videocam_off, color: Colors.white, size: 30),
            onPressed: () {},
          ),
          FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.red,
            child: const Icon(Icons.call_end, color: Colors.white),
          ),
          IconButton(
            icon: const Icon(Icons.volume_up, color: Colors.white, size: 30),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.add_call, color: Colors.white, size: 30),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
