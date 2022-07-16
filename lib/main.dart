import 'package:flutter/material.dart';
import 'login_page.dart';

void main() {
  runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // エミュレーター右上の「debug」という帯を消す
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

