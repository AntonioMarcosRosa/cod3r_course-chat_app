import 'dart:async';
import 'dart:math';

import 'package:chat/core/services/auth/auth_service.dart';
import 'package:chat/core/models/chat_user.dart';
import 'dart:io';

class AuthMockService implements AuthService {
  static final _defaultUser = ChatUser(
    id: '555',
    name: 'Antônio',
    email: 'guest@mail.com',
    imageUrl: 'lib\\assets\\images\\avatar-221027-170635.webp',
  );
  static Map<String, ChatUser> _users = {
    _defaultUser.email: _defaultUser,
  };
  static ChatUser? _currentUser;
  static MultiStreamController<ChatUser?>? _controller;
  static final _userStream = Stream<ChatUser?>.multi((controller) {
    _controller = controller;
    _updateUser(_defaultUser);
  });
  
  @override
  ChatUser? get currentUser => _currentUser;

  @override
  Future<void> logout() async => _updateUser(null);

  @override
  Future<void> signIn(String email, String password) async {
    _updateUser(_users[email]);
  }

  @override
  Future<void> signUp(
    String name,
    String email,
    String password,
    File? image,
  ) async {
    final newUser = ChatUser(
      id: Random().nextDouble().toString(),
      name: name,
      email: email,
      imageUrl: image?.path ?? 'lib\\assets\\images\\avatar-221027-170635.webp',
    );

    _users.putIfAbsent(email, () => newUser);
    _updateUser(newUser);
  }

  @override
  Stream<ChatUser?> get userChanges => _userStream;

  static void _updateUser(ChatUser? user) {
    _currentUser = user;
    _controller?.add(_currentUser);
  }
}
