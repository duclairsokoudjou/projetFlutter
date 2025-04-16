
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;


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
        return windows;
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
    apiKey: 'AIzaSyDcFLzuv7LVhF7DyidxiwdKriKZlZ85gtc',
    appId: '1:996787601832:web:73f8103057290bfaf55d9d',
    messagingSenderId: '996787601832',
    projectId: 'login-68fb5',
    authDomain: 'login-68fb5.firebaseapp.com',
    storageBucket: 'login-68fb5.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDLEF4homD9Jkzsyayax_HuzG1_SiIAcQQ',
    appId: '1:996787601832:android:b2041e19defa1810f55d9d',
    messagingSenderId: '996787601832',
    projectId: 'login-68fb5',
    storageBucket: 'login-68fb5.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAwXB-obwIpHhG_ZKwy_u_HnXWxt_IOW8E',
    appId: '1:996787601832:ios:6384ea876f2752e6f55d9d',
    messagingSenderId: '996787601832',
    projectId: 'login-68fb5',
    storageBucket: 'login-68fb5.firebasestorage.app',
    iosBundleId: 'com.example.login',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAwXB-obwIpHhG_ZKwy_u_HnXWxt_IOW8E',
    appId: '1:996787601832:ios:6384ea876f2752e6f55d9d',
    messagingSenderId: '996787601832',
    projectId: 'login-68fb5',
    storageBucket: 'login-68fb5.firebasestorage.app',
    iosBundleId: 'com.example.login',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDcFLzuv7LVhF7DyidxiwdKriKZlZ85gtc',
    appId: '1:996787601832:web:4e6cb08c86cbd4b8f55d9d',
    messagingSenderId: '996787601832',
    projectId: 'login-68fb5',
    authDomain: 'login-68fb5.firebaseapp.com',
    storageBucket: 'login-68fb5.firebasestorage.app',
  );

}