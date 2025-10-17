import 'package:chat_app/configs/color.config.dart';
import 'package:flutter/material.dart';

class ContactListItem extends StatelessWidget {
  final String name;
  final String? subtitle;
  final Widget avatar;
  final VoidCallback? onAdd;
  final bool isAdded;

  const ContactListItem({
    Key? key,
    required this.name,
    this.subtitle,
    required this.avatar,
    this.onAdd,
    this.isAdded = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onAdd,
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
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isDark
                            ? ColorConfig.neutral.neutral300
                            : ColorConfig.neutral.neutral500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            if (onAdd != null)
              ElevatedButton(
                onPressed: onAdd,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isAdded
                      ? (isDark
                          ? ColorConfig.neutral.neutral700
                          : ColorConfig.neutral.neutral200)
                      : ColorConfig.blue.blue500,
                  foregroundColor: isAdded
                      ? (isDark
                          ? ColorConfig.neutral.neutral400
                          : ColorConfig.neutral.neutral600)
                      : Colors.white,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                ),
                child: Text(isAdded ? 'Added' : 'Add'),
              )
          ],
        ),
      ),
    );
  }
}
