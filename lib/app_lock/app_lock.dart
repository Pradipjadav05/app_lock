import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app_lock/home_screen.dart';
import 'package:app_lock/lock_screen.dart';

class AppLock extends StatefulWidget {
  final Widget Function(Object?) builder;
  final bool enabled;
  final int lockDurationSeconds;
  final Widget lockScreen;
  final ThemeData? theme;

  const AppLock({
    Key? key,
    required this.builder,
    required this.lockScreen,
    this.enabled = true,
    this.lockDurationSeconds = 60,
    this.theme,
  }) : super(key: key);

  static AppLockState? of(BuildContext context) =>
      context.findAncestorStateOfType<AppLockState>();

  @override
  State<AppLock> createState() => AppLockState();
}

class AppLockState extends State<AppLock> with WidgetsBindingObserver {
  late bool _enabled;
  late bool _isLocked;
  late DateTime _lastResumedTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _enabled = widget.enabled;
    _isLocked = _enabled;
    _lastResumedTime = DateTime.now();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (!_enabled) return;

    if (state == AppLifecycleState.resumed) {
      final now = DateTime.now();
      final difference = now.difference(_lastResumedTime);
      // if resumed time is > widget.lockDurationSeconds then display lock screen
      if (difference.inSeconds > widget.lockDurationSeconds && _isLocked) {
        _showLockScreen();
      }
      _lastResumedTime = now;
    }
  }

  void _showLockScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => widget.lockScreen,
      ),
    );
    _isLocked = true;
  }

  void didUnlock() {
    setState(() {
      _isLocked = false;
    });
  }

  void enable() {
    setState(() {
      _enabled = true;
    });
  }

  void disable() {
    setState(() {
      _enabled = false;
      _isLocked = true; // Lock the app if disabled
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _isLocked ? widget.lockScreen : widget.builder(null),
      theme: widget.theme,
      routes: {
        '/lock-screen': (context) => widget.lockScreen,
      },
    );
  }
}
