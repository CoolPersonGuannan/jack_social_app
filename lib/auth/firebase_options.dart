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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCc9dZ0gKy118IC6UTUU4vyBzd807Qlv8A',
    appId: '1:881122469323:web:b3ead63c419aa9f7c6024e',
    messagingSenderId: '881122469323',
    projectId: 'chat-app-91a9d',
    authDomain: 'chat-app-91a9d.firebaseapp.com',
    databaseURL: 'https://chat-app-91a9d-default-rtdb.firebaseio.com',
    storageBucket: 'chat-app-91a9d.appspot.com',
    measurementId: 'G-0X3VYZ2877',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCaJmPtsAPo9KROns6q2uhwzDCX6_xHY4U',
    appId: '1:881122469323:android:a97ae1b7d6d7db86c6024e',
    messagingSenderId: '881122469323',
    projectId: 'chat-app-91a9d',
    databaseURL: 'https://chat-app-91a9d-default-rtdb.firebaseio.com',
    storageBucket: 'chat-app-91a9d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBKLW7guOzj3tDZUWzH6BwqatExC6WOlMo',
    appId: '1:881122469323:ios:c7c4a0530ed6f718c6024e',
    messagingSenderId: '881122469323',
    projectId: 'chat-app-91a9d',
    databaseURL: 'https://chat-app-91a9d-default-rtdb.firebaseio.com',
    storageBucket: 'chat-app-91a9d.appspot.com',
    androidClientId: '881122469323-4vgifp6vhnm4hhpsq917j7jpcuo34pfm.apps.googleusercontent.com',
    iosClientId: '881122469323-r1gv337jomt02h0jj8nbjitmmhfbnjbc.apps.googleusercontent.com',
    iosBundleId: 'com.codingminds.jacksocialapp.jackSocialAppV2',
  );
}