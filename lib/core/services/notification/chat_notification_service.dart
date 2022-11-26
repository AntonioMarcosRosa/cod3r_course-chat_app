import 'package:chat/core/models/chat_notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

class ChatNotificationService with ChangeNotifier {
  List<ChatNotification> _items = [];

  List<ChatNotification> get items => [..._items];

  int get totalItems => _items.length;

  void add(ChatNotification notification) {
    _items.add(notification);
    notifyListeners();
  }

  void remove(int notificationIndex) {
    _items.removeAt(notificationIndex);
    notifyListeners();
  }

  Future<void> init() async {
    await _configureTerminated();
    await _configureForeground();
    await _configureBackground();
  }

  Future<bool> get _isAuthorized async {
    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission();
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  Future<void> _configureForeground() async {
    if (await _isAuthorized) {
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        _messageHandler(message);
      });
    }
  }

  Future<void> _configureTerminated() async {
    if (await _isAuthorized) {
      RemoteMessage? initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      _messageHandler(initialMessage);
    }
  }

  Future<void> _configureBackground() async {
    if (await _isAuthorized) {
      FirebaseMessaging.onMessage.listen((message) {
        _messageHandler(message);
      });
    }
  }

  void _messageHandler(RemoteMessage? message) {
    if (message?.notification == null) return;
    add(ChatNotification(
      title: message?.notification!.title ?? 'Not informed',
      body: message?.notification!.body ?? 'Not informed',
    ));
  }
}
