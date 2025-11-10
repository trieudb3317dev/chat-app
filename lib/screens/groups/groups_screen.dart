import 'package:chat_app/common/group_list_item.dart';
import 'package:chat_app/providers/group_provider.dart';
import 'package:chat_app/screens/groups/group_conversation_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({Key? key}) : super(key: key);

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GroupProvider>(context, listen: false).fetchGroups();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Groups'),
      ),
      body: Consumer<GroupProvider>(
        builder: (context, groupProvider, child) {
          if (groupProvider.isLoading && groupProvider.groups.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (groupProvider.error != null) {
            return Center(child: Text(groupProvider.error!));
          }

          if (groupProvider.groups.isEmpty) {
            return const Center(child: Text('You are not in any group yet.'));
          }

          return RefreshIndicator(
            onRefresh: () => groupProvider.fetchGroups(),
            child: ListView.builder(
              itemCount: groupProvider.groups.length,
              itemBuilder: (context, index) {
                final group = groupProvider.groups[index];
                if (group == null) {
                  return const SizedBox.shrink();
                }

                return GroupListItem(
                  name: group['name'] ?? 'Unknown Group',
                  lastMessage: '${group['members']?.length ?? 0} members', // Use member count as subtitle
                  avatar: CircleAvatar(
                    backgroundImage: NetworkImage(group['avatar'] ?? 'https://via.placeholder.com/150'),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => GroupConversationScreen(group: group),
                    ));
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
