import 'dart:async';

import 'package:flutter/material.dart';
import 'package:passcode_screen/passcode_screen.dart';

import 'app_lock/app_lock.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {

  final StreamController<bool> _verificationNotifier = StreamController<bool>.broadcast();

  void _onPasscodeEntered(String enteredPasscode) {
    bool isValid = '1234' == enteredPasscode;
    _verificationNotifier.add(isValid);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: PasscodeScreen(
        title: const Text(
          "Passcode",
          style: TextStyle(
            fontSize: 32,
            color: Colors.white,
          ),
        ),
        passwordDigits: 4,
        passwordEnteredCallback: _onPasscodeEntered,
        cancelButton: const Text('Cancel'),
        deleteButton: const Text('Delete'),
        shouldTriggerVerification: _verificationNotifier.stream,
        isValidCallback: () {
          AppLock.of(context)?.didUnlock();
        },
      ),
    );
  }
}
