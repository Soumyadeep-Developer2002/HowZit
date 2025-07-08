import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:how_zit/extra_features/hereAPI.dart';
import 'package:how_zit/extra_features/some_features.dart';
import 'package:how_zit/main.dart';
import 'package:how_zit/pages/chat_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreensState();
}

class _LoginScreensState extends State<LoginScreen> {
  _handleSignin() {
    Features.progressionBar(context);
    _signInWithGoogle().then((User) async {
      Navigator.pop(context);
      if (User != null) {
        print('\nUser:  ${User.user}');
        print('\nUser.additionalInfo:  ${User.additionalUserInfo}');

        if ((await hereAllAPI.ifUserExist())) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => ChatScreen()),
          );
        } else {
          await hereAllAPI.ifUserDontExist().then((value) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => ChatScreen()),
            );
          });
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await hereAllAPI.auth.signInWithCredential(credential);
    } catch (e) {
      print('_signInWithGoogle: $e');
      Features.showSnackBar(context, 'Oops! Something went wrong');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    mquery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade300,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "How",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              TextSpan(
                text: "Zit",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: mquery.height * .5,
            width: mquery.width * .70,
            left: mquery.width * .15,
            height: mquery.height * .06,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(elevation: 5),
              onPressed: () {
                _handleSignin();
              },
              icon: Image.asset(
                'assets/images/google.png',
                height: mquery.height * .05,
              ),
              label: Text("Sign in with Google"),
            ),
          ),
          Positioned(
            bottom: mquery.height * .0,
            width: mquery.width * .6,
            left: mquery.width * .2,
            child: Text("HowZit | Version: 1.0 | SOUMYADEEP"),
          ),
        ],
      ),
    );
  }
}
