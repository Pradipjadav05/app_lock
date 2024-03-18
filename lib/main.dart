import 'package:app_lock/app_lock/app_lock.dart';
import 'package:app_lock/home_screen.dart';
import 'package:app_lock/lock_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AppLock(
      builder: (args) {
        return MaterialApp(
          title: 'Flutter App Lock',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          routes: <String, WidgetBuilder>{
            '/': (context) => const HomeScreen(),
          },
        );
      },
      enabled: true,
      lockScreen: const LockScreen(),
    );
  }
}
