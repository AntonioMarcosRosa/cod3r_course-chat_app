import 'dart:math';
import 'package:chat/components/messages.dart';
import 'package:chat/components/new_message.dart';
import 'package:chat/core/models/chat_notification.dart';
import 'package:chat/core/services/auth/auth_service.dart';
import 'package:chat/pages/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/services/notification/chat_notification_service.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final totalNotifications =
        Provider.of<ChatNotificationService>(context).totalItems;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton(
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).primaryIconTheme.color,
              ),
              items: [
                DropdownMenuItem(
                  value: 'logout',
                  child: Container(
                    child: Row(
                      children: const [
                        Icon(
                          Icons.exit_to_app,
                          color: Colors.black87,
                        ),
                        SizedBox(width: 8),
                        Text('Leave'),
                      ],
                    ),
                  ),
                ),
              ],
              onChanged: (value) {
                if (value == 'logout') AuthService().logout();
              },
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: ((context) => const NotificationPage()))),
            child: Stack(
              children: [
                Container(
                    margin: const EdgeInsets.only(top: 12, right: 8),
                    child: const Icon(Icons.notifications, size: 26)),
                if (totalNotifications > 0)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: CircleAvatar(
                      maxRadius: 8,
                      backgroundColor: Colors.red.shade800,
                      child: Text(
                        totalNotifications > 9 ? '+9' : '$totalNotifications',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  )
              ],
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Expanded(
              child: Messages(),
            ),
            NewMessage(),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () =>
      //       Provider.of<ChatNotificationService>(context, listen: false).add(
      //           ChatNotification(
      //               title: 'title', body: Random().nextDouble().toString())),
      //   child: Icon(Icons.add),
      // ),
    );
  }
}
