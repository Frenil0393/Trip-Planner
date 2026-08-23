import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock Firebase Auth Stream. Defaulting to logged in for prototype.
    const bool isUserLoggedIn = true; 

    if (isUserLoggedIn) {
      return const HomeScreen();
    }
    return const LoginScreen();
  }
}
