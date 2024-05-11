import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_push_notification/firebase_options.dart';
import 'package:flutter_push_notification/models/push_message.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationsBloc() : super(const NotificationsState()) {
    on<NotificationStatusChanged>(_notificationsStatusChanged);
    _checkPermissionFCM();
    _onForegroundMessage();
  }

  static Future<void> initializeFCM() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  void _notificationsStatusChanged(
      NotificationStatusChanged event, Emitter<NotificationsState> emit) {
    emit(state.copyWith(status: event.status));
    _getFcmToken();
  }

  void _handleRemoteMessage(RemoteMessage message) {
    if (message.notification != null) {
      final notification = mapRemoteMessageToEntity(message);
      print(notification.toString());
    } else {
      print("Received a data-only message: ${message.data}");
    }
  }

  PushMessage mapRemoteMessageToEntity(RemoteMessage message) {
    return PushMessage(
      messageId: mapMessageId(message.messageId),
      title: message.notification?.title ?? '',
      body: message.notification?.body ?? '',
      sentDate: message.sentTime ?? DateTime.now(),
      data: message.data,
      imageUrl: _getImageUrl(message.notification),
    );
  }

  String mapMessageId(String? messageId) {
    return messageId?.replaceAll(':', '')?.replaceAll('%', '') ?? '';
  }

  String? _getImageUrl(RemoteNotification? notification) {
    if (notification == null) return null;
    return Platform.isAndroid
        ? notification.android?.imageUrl
        : notification.apple?.imageUrl;
  }

  void _onForegroundMessage() {
    FirebaseMessaging.onMessage.listen(_handleRemoteMessage);
  }

  void _checkPermissionFCM() async {
    final settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
    add(NotificationStatusChanged(settings.authorizationStatus));
  }

  void _getFcmToken() async {
    final settings = await messaging.getNotificationSettings();
    if (settings.authorizationStatus != AuthorizationStatus.authorized) return;
    final token = await messaging.getToken();

    print(token);
  }

  void requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
    add(NotificationStatusChanged(settings.authorizationStatus));
  }
}
