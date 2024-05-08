import 'package:flutter/material.dart';
import 'package:flutter_push_notification/config/routers/routers.dart';
import 'package:flutter_push_notification/config/theme/theme.dart';
import 'package:flutter_push_notification/presentation/notification/notifications_bloc.dart';
import 'package:flutter_push_notification/presentation/providers/head_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationsBloc.initializeFCM();
  runApp(HeadProvider.initProvider(mainAppWidget: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
    );
  }
}
