import 'package:blockchain/Login/AuthCheck.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:web3dart/web3dart.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'INRTet',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: false
      ),
      debugShowCheckedModeBanner: false,
      home: Authcheck(),
    );
  }
}