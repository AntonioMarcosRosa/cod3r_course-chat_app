import 'dart:async';
import 'package:chat/core/services/auth/auth_service.dart';
import 'package:chat/core/models/chat_user.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

    final imageName = '${credential.user!.uid}.jpg';
    final imageURl = await _uploadUserImage(image, imageName);

    await credential.user?.updateDisplayName(name);
    await credential.user?.updatePhotoURL(imageURl);

    _currentUser = _toChatUser(credential.user!, name, imageURl);

    await _saveChatUser(_currentUser!);
  }

  @override
  Stream<ChatUser?> get userChanges => _userStream;

  Future<String?> _uploadUserImage(File? image, String imageName) async {
    if (image == null) return null;

    final storage = FirebaseStorage.instance;

    final imageRef = storage.ref().child('user_images').child(imageName);

    await imageRef.putFile(image).whenComplete(() => null);

    return await imageRef.getDownloadURL();
  }

  Future<void> _saveChatUser(ChatUser user) async {
    final store = FirebaseFirestore.instance;
    final docRef = store.collection('users').doc(user.id);
    return docRef.set({
      'name': user.name,
      'email': user.email,
      'imageUrl': user.imageUrl,
    });
  }

  static ChatUser _toChatUser(User user, [String? name, String? imageUrl]) {
    return ChatUser(
      id: user.uid,
      name: name ?? user.displayName ?? user.email!.split('@')[0],
      email: user.email!,
      imageUrl: imageUrl ??
          user.photoURL ??
          'lib/assets/images/avatar-221027-170635.webp',
    );
  }
}
