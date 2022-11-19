import 'dart:async';
import 'package:chat/core/services/auth/auth_service.dart';
import 'package:chat/core/models/chat_user.dart';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

class AuthFirebaseService implements AuthService {
  static ChatUser? _currentUser;
  static final _userStream = Stream<ChatUser?>.multi((controller) async {
    final authChanges = FirebaseAuth.instance.authStateChanges();
    await for (final user in authChanges) {
      _currentUser = user == null ? null : _toChatUser(user);
      controller.add(_currentUser);
    }
  });

  @override
  ChatUser? get currentUser => _currentUser;

  @override
  Future<void> logout() async => FirebaseAuth.instance.signOut();

  @override
  Future<void> signIn(String email, String password) async {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> signUp(
    String name,
    String email,
    String password,
    File? image,
  ) async {
    final auth = FirebaseAuth.instance;
    UserCredential credential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);

    if (credential.user == null) return;

    credential.user?.updateDisplayName(name);
    //credential.user?.updatePhotoURL(image);
  }

  @override
  Stream<ChatUser?> get userChanges => _userStream;

  static ChatUser _toChatUser(User user) {
    return ChatUser(
      id: user.uid,
      name: user.displayName ?? user.email!.split('@')[0],
      email: user.email!,
      imageUrl: user.photoURL ?? 'lib/assets/images/avatar-221027-170635.webp',
    );
  }
}
