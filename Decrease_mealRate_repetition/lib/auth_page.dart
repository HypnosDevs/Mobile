import 'package:final_project/login_page.dart';
import 'package:final_project/signup_page.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
bool isLogin = true;

  @override
  Widget build(BuildContext context) =>
    isLogin 
    ? LoginWidget(onClickedSignUp: toggle,)
    : SignUpWidget(onClickedSignIn: toggle);

  void toggle() => setState(() => isLogin = !isLogin);
}