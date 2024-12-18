import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBu-cG8hXtj1nucaYFY-NhFw8tc4jnB8Us",
            authDomain: "login-with-pin-w14ova.firebaseapp.com",
            projectId: "login-with-pin-w14ova",
            storageBucket: "login-with-pin-w14ova.firebasestorage.app",
            messagingSenderId: "456456866601",
            appId: "1:456456866601:web:be78dd5948a1535dc94538"));
  } else {
    await Firebase.initializeApp();
  }
}
