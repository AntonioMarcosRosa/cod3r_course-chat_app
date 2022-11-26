import 'dart:async';
import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/models/chat_message.dart';
import 'package:chat/core/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChatFirebaseService implements ChatService {
  @override
  Stream<List<ChatMessage>> messagesStream() {
    final store = FirebaseFirestore.instance;

    final snapshots = store
        .collection('chat')
        .withConverter(
          fromFirestore: _fromFirestore,
          toFirestore: _toFirestore,
        )
        .orderBy('createdAt', descending: true)
        .snapshots();

    return snapshots
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());

    // return Stream<List<ChatMessage>>.multi((controller) {
    //   snapshots.listen((snapshot) {
    //     List<ChatMessage> chatMessages =
    //         snapshot.docs.map((doc) => doc.data()).toList();
    //     controller.add(chatMessages);
    //   });
    // });
  }

  @override
  Future<ChatMessage?> save(String text, ChatUser user) async {
    final store = FirebaseFirestore.instance;

    final message = ChatMessage(
      id: '',
      text: text,
      createdAt: DateTime.now(),
      userId: user.id,
      userName: user.name,
      userImageUrl: user.imageUrl,
    );

    final docRef = await store
        .collection('chat')
        .withConverter(fromFirestore: _fromFirestore, toFirestore: _toFirestore)
        .add(message);

    final doc = await docRef.get();

    return doc.data();
  }

  ChatMessage _fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
    SnapshotOptions? options,
  ) {
    return ChatMessage(
      id: doc.id,
      text: doc['text'],
      createdAt: DateTime.parse(doc['createdAt']),
      userId: doc['userId'],
      userName: doc['userName'],
      userImageUrl: doc['userImageUrl'],
    );
  }

  Map<String, dynamic> _toFirestore(
      ChatMessage chatMessage, SetOptions? options) {
    return {
      'text': chatMessage.text,
      'createdAt': chatMessage.createdAt.toIso8601String(),
      'userId': chatMessage.userId,
      'userName': chatMessage.userName,
      'userImageUrl': chatMessage.userImageUrl,
    };
  }
}
