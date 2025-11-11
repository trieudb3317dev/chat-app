import 'package:flutter/material.dart';
import 'package:chat_app/configs/color.config.dart';

class ConversationListItem extends StatelessWidget {
  final int id;
  final String name;
  final String lastMessage;
  final dynamic time; // changed from String to dynamic to accept DateTime or String
  final int unreadCount;
  final Widget avatar;
  final bool isMuted;
  final bool isSender; // added field
  final VoidCallback onTap;

  const ConversationListItem({
    Key? key,
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    required this.avatar,
    this.isMuted = false,
    this.isSender = false, // default false
    required this.onTap,
  }) : super(key: key);

  String _formatTime(dynamic t) {
    if (t == null) return '';
    DateTime? dt;
    if (t is DateTime) {
      dt = t;
    } else if (t is String) {
      dt = DateTime.tryParse(t);
      if (dt == null) {
        // if it's already like "HH:mm" or other format, return as is
        return t;
      }
    } else if (t is int) {
      dt = DateTime.fromMillisecondsSinceEpoch(t);
    } else {
      return t.toString();
    }

    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inDays >= 1) {
      return '${dt.year.toString().padLeft(4, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}';
    } else {
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final displayTime = _formatTime(time);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            avatar,
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDark ? ColorConfig.neutral.neutral300 : ColorConfig.neutral.neutral500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  displayTime,
                  style: TextStyle(
                    color: isDark ? ColorConfig.neutral.neutral400 : ColorConfig.neutral.neutral500,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                if (!isSender && unreadCount > 0) // show badge only for recipient
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: ColorConfig.blue.blue500,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 24), // to align with badge
              ],
            ),
          ],
        ),
      ),
    );
  }
}
