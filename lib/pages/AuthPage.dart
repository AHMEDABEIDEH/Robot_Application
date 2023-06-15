import 'package:flutter/material.dart';
import 'package:robot_application/pages/LoginPage.dart';
import 'package:robot_application/pages/RegisterPage.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool islogin = true;
  @override
  Widget build(BuildContext context) => islogin
      ? LoginWidget(showRegisterPage: toggle)
      : registerPage(onClickedSignIn: toggle);

  void toggle() => setState(() => islogin = !islogin);
}
