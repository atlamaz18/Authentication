import 'package:flutter/material.dart';
import 'package:authentication/View/Welcome/WelcomeLayout.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WelcomeLayout(),
    );
  }
}