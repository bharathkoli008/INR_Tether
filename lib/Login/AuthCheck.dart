import 'package:blockchain/Frame.dart';
import 'package:blockchain/Login/Login.dart';
import 'package:blockchain/MyhomePage.dart';
import 'package:blockchain/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';



class Authcheck extends StatefulWidget {
  const Authcheck({Key? key}) : super(key: key);

  @override
  State<Authcheck> createState() => _AuthcheckState();
}

class _AuthcheckState extends State<Authcheck> {
  bool userAvailabe = false;
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    _getuser();
    super.initState();
  }

  void _getuser() async {
    sharedPreferences = await SharedPreferences.getInstance();

    try{
      if(sharedPreferences.getString('id') != null){
        setState(() {
          userAvailabe = true;
        });
      }
    } catch(e){
      setState(() {
        userAvailabe = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return userAvailabe ? MyHomePage(title: 'INR TEther') : Login();
  }
}


