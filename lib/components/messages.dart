import 'package:chat/components/message_bubble.dart';
import 'package:chat/core/services/auth/auth_service.dart';
import 'package:chat/core/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = AuthService().currentUser;

    return StreamBuilder(
        stream: ChatService().messagesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Nenhuma mensagem nesse chat'),
            );
          } else {
            final msgs = snapshot.data!;
            return ListView.builder(
              reverse: true,
              itemCount: msgs.length,
              itemBuilder: (context, index) => MessageBubble(
                key: ValueKey(msgs[index].id),
                message: msgs[index],
                belongsToCurrrentUser:
                    currentUser?.id == msgs[index].userId ? true : false,
              ),
            );
          }
        });
  }
}
