import 'dart:io';

import 'package:chat/core/models/chat_message.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  static const _defaultImagePath =
      'lib/assets/images/avatar-221027-170635.webp';
  final ChatMessage message;
  final bool belongsToCurrrentUser;

  const MessageBubble({
    super.key,
    required this.message,
    required this.belongsToCurrrentUser,
  });

  Widget _showUserImage(String imageUrl) {
    ImageProvider? provider;
    final uri = Uri.parse(imageUrl);

    if (uri.path.contains(_defaultImagePath)) {
      print(_defaultImagePath);
      provider = const AssetImage(_defaultImagePath);
    } else if (uri.scheme.contains('http')) {
      provider = NetworkImage(uri.toString());
    } else {
      provider = FileImage(File(uri.toString()));
    }

    return CircleAvatar(
      backgroundImage: provider,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: belongsToCurrrentUser
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Container(
                decoration: BoxDecoration(
                  color: belongsToCurrrentUser
                      ? Colors.grey.shade300
                      : Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(8),
                    topRight: const Radius.circular(8),
                    bottomLeft: belongsToCurrrentUser
                        ? const Radius.circular(8)
                        : const Radius.circular(0),
                    bottomRight: belongsToCurrrentUser
                        ? const Radius.circular(0)
                        : const Radius.circular(8),
                  ),
                ),
                width: 180,
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                margin: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 8,
                ),
                child: Column(
                  crossAxisAlignment: belongsToCurrrentUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.userName,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: belongsToCurrrentUser
                              ? Colors.black87
                              : Colors.white),
                    ),
                    Text(
                      message.text,
                      textAlign: belongsToCurrrentUser
                          ? TextAlign.right
                          : TextAlign.left,
                      style: TextStyle(
                          color: belongsToCurrrentUser
                              ? Colors.black87
                              : Colors.white),
                    ),
                  ],
                )),
          ],
        ),
        Positioned(
            top: 0,
            left: belongsToCurrrentUser ? null : 165,
            right: belongsToCurrrentUser ? 165 : null,
            child: _showUserImage(message.userImageUrl)),
      ],
    );
  }
}
