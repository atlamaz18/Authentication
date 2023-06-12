import 'package:flutter/material.dart';
import 'package:authentication/View/Welcome/WelcomeLayout.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();  
  
  await dotenv.load();
  runApp(const MyApp()); 
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Authentication',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0XFFF8F8F8),
      ),
      home: WelcomeLayout(),
    );
  }
}
