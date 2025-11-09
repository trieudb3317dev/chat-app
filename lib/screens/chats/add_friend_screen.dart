import 'package:chat_app/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({Key? key}) : super(key: key);

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  final TextEditingController _phoneController = TextEditingController();

  void _searchUser() {
    if (_phoneController.text.isNotEmpty) {
      Provider.of<ProfileProvider>(context, listen: false).searchUser(_phoneController.text);
    }
  }

  Future<void> _addFriend(String phoneNumber) async {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final success = await profileProvider.assignToFriend(phoneNumber);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Friend added successfully!' : profileProvider.error ?? 'Failed to add friend.'),
        ),
      );
      if (success) {
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Friend'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Enter Phone Number',
                prefixIcon: const Icon(Icons.phone),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchUser,
                ),
              ),
              onSubmitted: (_) => _searchUser(),
            ),
            const SizedBox(height: 20),
            Consumer<ProfileProvider>(
              builder: (context, provider, child) {
                if (provider.isSearching) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.searchedUser != null) {
                  final user = provider.searchedUser!;
                  final profile = user['profile'] ?? {};
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(profile['avatar'] ?? 'https://via.placeholder.com/150'),
                    ),
                    title: Text(user['name'] ?? 'Unknown User'),
                    subtitle: Text(user['phone'] ?? ''),
                    trailing: IconButton(
                      icon: const Icon(Icons.add_circle, color: Colors.green),
                      onPressed: () => _addFriend(user['phone']),
                    ),
                  );
                }

                if (provider.error != null) {
                  return Center(child: Text(provider.error!));
                }
                
                return const Center(child: Text('Enter a phone number to search for a user.'));
              },
            ),
          ],
        ),
      ),
    );
  }
}
