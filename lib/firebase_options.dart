// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBVAO0k6jAHRTshuZG2hs0ZAOn3Ww3ELKU',
    appId: '1:1059294772251:web:576078f451a133dbcb0cbe',
    messagingSenderId: '1059294772251',
    projectId: 'mit-bus-app',
    authDomain: 'mit-bus-app.firebaseapp.com',
    storageBucket: 'mit-bus-app.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyArkOE6o6uxbW5VzTXWc4Zr6roQc6xof14',
    appId: '1:1059294772251:android:635e73d274bbc03acb0cbe',
    messagingSenderId: '1059294772251',
    projectId: 'mit-bus-app',
    storageBucket: 'mit-bus-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB4DL8Hg68yK25VLxivoATG5Qf9qHDlYx4',
    appId: '1:1059294772251:ios:1fccaa7934fca48ecb0cbe',
    messagingSenderId: '1059294772251',
    projectId: 'mit-bus-app',
    storageBucket: 'mit-bus-app.appspot.com',
    iosClientId: '1059294772251-9ktrfr4j11qesbt3v856s7dgbptrloqk.apps.googleusercontent.com',
    iosBundleId: 'com.example.mitBusApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB4DL8Hg68yK25VLxivoATG5Qf9qHDlYx4',
    appId: '1:1059294772251:ios:1fccaa7934fca48ecb0cbe',
    messagingSenderId: '1059294772251',
    projectId: 'mit-bus-app',
    storageBucket: 'mit-bus-app.appspot.com',
    iosClientId: '1059294772251-9ktrfr4j11qesbt3v856s7dgbptrloqk.apps.googleusercontent.com',
    iosBundleId: 'com.example.mitBusApp',
  );
}
