import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_managment/ui/screens/home_screen.dart';

import '../../utils/authentication.dart';
import '../../utils/validator.dart';
import '../auth_screen/sign_in_screen.dart';
import '../widgets/buttonWidget.dart';
import 'custom_form_field.dart';

class RegisterForm extends StatefulWidget {
  final FocusNode nameFocusNode;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;

  const RegisterForm({
    Key? key,
    required this.nameFocusNode,
    required this.emailFocusNode,
    required this.passwordFocusNode,
  }) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _registerFormKey = GlobalKey<FormState>();

  bool _isSingningUp = false;

  User? user;

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SignInScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _registerFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
            ),
            child: Column(
              children: [
                CustomFormField(
                  controller: _nameController,
                  focusNode: widget.nameFocusNode,
                  keyboardType: TextInputType.name,
                  inputAction: TextInputAction.next,
                  isCapitalized: true,
                  validator: (value) => Validator.validateName(
                    name: value,
                  ),
                  label: 'Name',
                  hint: 'Enter your name',
                ),
                SizedBox(height: 16.0),
                CustomFormField(
                  controller: _emailController,
                  focusNode: widget.emailFocusNode,
                  keyboardType: TextInputType.emailAddress,
                  inputAction: TextInputAction.next,
                  validator: (value) => Validator.validateEmail(
                    email: value,
                  ),
                  label: 'Email',
                  hint: 'Enter your email',
                ),
                SizedBox(height: 16.0),
                CustomFormField(
                  controller: _passwordController,
                  focusNode: widget.passwordFocusNode,
                  keyboardType: TextInputType.text,
                  inputAction: TextInputAction.done,
                  validator: (value) => Validator.validatePassword(
                    password: value,
                  ),
                  isObscure: true,
                  label: 'Password',
                  hint: 'Enter your password',
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          _isSingningUp
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.blue,
                    ),
                  ),
                )
              : MyButton(
                  height: 50,
                  width: 200,
                  label: "Register",
                  onTap: () async {
                    widget.emailFocusNode.unfocus();
                    widget.passwordFocusNode.unfocus();

                    setState(() {
                      _isSingningUp = true;
                    });

                    if (_registerFormKey.currentState!.validate()) {
                      User? user =
                          await Authentication.registerUsingEmailPassword(
                        name: _nameController.text,
                        email: _emailController.text,
                        password: _passwordController.text,
                        context: context,
                      );

                      if (user != null) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => HomePage(

                            ),
                          ),
                        );
                      }
                    }

                    setState(() {
                      _isSingningUp = false;
                    });
                  },
                ),
          SizedBox(height: 20.0),
          InkWell(
            onTap: () {
              Navigator.of(context).pushReplacement(
                _routeToSignInScreen(),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style: TextStyle(
                    color: Get.isDarkMode ? Colors.black : Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  ' Sign in',
                  style: TextStyle(
                    color: Colors.blue,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
