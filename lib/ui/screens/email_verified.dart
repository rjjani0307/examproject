import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../res/custom_colors.dart';
import '../../utils/authentication.dart';

class Email_Verified extends StatefulWidget {
  const Email_Verified({Key? key}) : super(key: key);

  @override
  State<Email_Verified> createState() => _Email_VerifiedState();
}

class _Email_VerifiedState extends State<Email_Verified> {

  late bool _isEmailVerified;
  late User? _user;

  bool _verificationEmailBeingSent = false;

  @override
  void initState() {
    _isEmailVerified = _user!.emailVerified;

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 24.0),
          _isEmailVerified
              ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: Material(
                  color: Colors.greenAccent.withOpacity(0.6),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.check,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.0),
              Text(
                'Email is verified',
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 20,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          )
              : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: Material(
                  color: Colors.redAccent.withOpacity(0.8),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.0),
              Text(
                'Email is not verified',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 20,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Visibility(
            visible: !_isEmailVerified,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _verificationEmailBeingSent
                    ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    CustomColors.firebaseGrey,
                  ),
                )
                    : ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      CustomColors.firebaseGrey,
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    setState(() {
                      _verificationEmailBeingSent = true;
                    });
                    await _user!.sendEmailVerification();
                    setState(() {
                      _verificationEmailBeingSent = false;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Text(
                      'Verify',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.firebaseNavy,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () async {
                    User? user = await Authentication.refreshUser(_user!);

                    if (user != null) {
                      setState(() {
                        _user = user;
                        _isEmailVerified = user.emailVerified;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 16.0),

        ],
      ),
    );
  }
}
