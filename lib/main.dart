import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:login/cart_provider.dart';

import 'package:login/home_screen.dart';

import 'package:login/login_screen.dart';
import 'package:login/my_cart.dart';
import 'package:login/sign_in.dart';
import 'package:login/sign_up.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    runApp(ChangeNotifierProvider(create: (context)=>  CartProvider(), child: const MyApp(),));
 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignUP(),
      
      routes: {
        '/signin': (context) => SignUP(),    // <-- ton écran de connexion
        '/signup': (context) => SignUP(),    // <-- ton écran d'inscription

      },
    );
  }
}
