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

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDcx5yLbc8B4chDHNdKjVNI2EaaXWtbbyg',
    appId: '1:948840345517:ios:ee7c62122fd1d5d249bb24',
    messagingSenderId: '948840345517',
    projectId: 'camlica-pts-e08e8',
    storageBucket: 'camlica-pts-e08e8.firebasestorage.app',
    iosBundleId: 'com.riteknoloji.camlicaptss',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB6Cd7_OJ9cc7_-JuhGKWIqPJi37DlgodY',
    appId: '1:948840345517:android:f19f42e7d86aed6449bb24',
    messagingSenderId: '948840345517',
    projectId: 'camlica-pts-e08e8',
    storageBucket: 'camlica-pts-e08e8.firebasestorage.app',
  );

}