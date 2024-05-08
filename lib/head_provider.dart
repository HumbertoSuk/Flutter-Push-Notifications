import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_push_notification/presentation/notification/notifications_bloc.dart';

class HeadProvider {
  static MultiBlocProvider initProvider({required Widget mainAppWidget}) =>
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => NotificationsBloc(),
          ),
        ],
        child: mainAppWidget,
      );
}
