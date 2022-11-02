import 'package:chatapp/screens/signin.dart';
import 'package:chatapp/screens/signup.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  @override
  Widget build(BuildContext context) => isLogin
      ? SignIn(onClickedSignUp: toggle)
      : SignUp(onClickedLogin: toggle);

  void toggle() => setState(() {
        isLogin = !isLogin;0;
      });
}
