import 'dart:html';

import 'package:apiplayground/firebase_options.dart';
import 'package:apiplayground/widgets/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:apiplayground/views/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'dart:ui_web' as ui;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
   ui.platformViewRegistry.registerViewFactory(
    'editor-div',
    (int viewId) => DivElement()..id = 'editor',
  );
  runApp(const Main());
}

class Main extends StatefulWidget {
  const Main({super.key});

  // This widget is the root of your application.
  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: StreamBuilder<auth.User?>(
        stream: auth.FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            auth.User? firebaseUser = snapshot.data;
            if (firebaseUser == null) {
              return LoginScreen();
            } else {
              return MainNavigationScreen();
            }
          }
          return CircularProgressIndicator(); // Checking auth state
        },
      ),
    );
  }
}
