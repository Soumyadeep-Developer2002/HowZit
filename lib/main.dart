import 'package:flutter/material.dart';
import 'package:how_zit/pages/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

late Size mquery; // accessing for total screen size...

initializeFire() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Initialize firebase in Parent screen...
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeFire();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    mquery = MediaQuery.of(context).size; // Initialize mquery with Mediaquery.
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HowZit',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 60, 208, 114),
        ),
      ),
      home: SplashScreen(),
    );
  }
}
