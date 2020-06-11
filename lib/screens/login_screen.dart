import 'package:flutter/material.dart';
import '../widgets/login_widget.dart';

class LoginScreen extends StatefulWidget {
  final String locationSk, counterSk;
  LoginScreen(this.locationSk, this.counterSk);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return LoginWidget(
      widget.locationSk,
      widget.counterSk,
    );
  }
}
