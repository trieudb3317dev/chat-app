import 'package:flutter/material.dart';

class GroupListItem extends StatelessWidget {
  final String name;
  final String lastMessage;
  final Widget avatar;
  final VoidCallback? onTap;

  const GroupListItem({
    Key? key,
    required this.name,
    required this.lastMessage,
    required this.avatar,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: avatar,
      title: Text(name),
      subtitle: Text(lastMessage),
      onTap: onTap,
    );
  }
}
