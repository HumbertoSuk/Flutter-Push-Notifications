import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_push_notification/firebase_options.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationsBloc() : super(const NotificationsState()) {
    on<NotificationStatusChanged>(_notificationsStatusChanged);
    _checkPermissionFcM();
  }

  static Future<void> initializeFCM() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  void _notificationsStatusChanged(
      NotificationStatusChanged event, Emitter<NotificationsState> emit) {
    emit(state.copywith(status: event.status));
    _getFcmToken();
  }

  void _checkPermissionFcM() async {
    final setting = await messaging.getNotificationSettings();
    add(NotificationStatusChanged(setting.authorizationStatus));
  }

  void _getFcmToken() async {
    final setting = await messaging.getNotificationSettings();
    if (setting.authorizationStatus != AuthorizationStatus.authorized) return;
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
