import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../auth_screen/sign_in_screen.dart';
import 'home_screen.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Future<bool> _isUserLoggedIn() async {
    await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePage(

          ),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => SignInScreen(),
        ),
      );
    }

    return user == null ? false : true;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isUserLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Icon(
        Icons.done_all,
        size: 200,
        color: Colors.blue,
      )),
    );
  }
}
