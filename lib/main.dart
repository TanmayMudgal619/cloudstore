import 'package:cloudstore/screens/home.dart';
import 'package:cloudstore/screens/login.dart';
import 'package:cloudstore/screens/setuser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      home: (firebaseAuth.currentUser == null)
          ? (const Login())
          : (firebaseAuth.currentUser!.displayName == null)
              ? (const setUser())
              : (const Home()),
    );
  }
}
