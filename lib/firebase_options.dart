// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBGN7xVFYcvYGy6DWWPCVK61O2UqUFUKeo',
    appId: '1:89889293057:android:bd6ed5bcda79cc3fd49100',
    messagingSenderId: '89889293057',
    projectId: 'how-zit-c8fd7',
    storageBucket: 'how-zit-c8fd7.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDpR2rkFfbFL2RA1fkXSE1v7NVEMsJQUmk',
    appId: '1:89889293057:ios:1679563358abec85d49100',
    messagingSenderId: '89889293057',
    projectId: 'how-zit-c8fd7',
    storageBucket: 'how-zit-c8fd7.firebasestorage.app',
    androidClientId: '89889293057-417q6nhr9eo7vvc65nmujee0movu20ro.apps.googleusercontent.com',
    iosClientId: '89889293057-47pq5tvuqmblm1j757eom3tgtj4of63n.apps.googleusercontent.com',
    iosBundleId: 'com.example.howZit',
  );

}