import 'package:flutter/material.dart';
import 'package:how_zit/extra_features/hereAPI.dart';
import 'package:how_zit/pages/chat_screen.dart';
import 'package:how_zit/pages/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      if (hereAllAPI.auth.currentUser != null) {
        print('\nUser:  ${hereAllAPI.auth.currentUser}');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ChatScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 100,
          width: 100,
          child: Image.asset('assets/images/logo.png'),
        ),
      ),
    );
  }
}
