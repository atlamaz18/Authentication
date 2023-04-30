import 'package:authentication/View/Main/MainLayout.dart';
import 'package:flutter/material.dart';
import '../SignUp/SignUpLayout.dart';
import '../Login/LoginLayout.dart';

class WelcomeLayout extends StatelessWidget {
  const WelcomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0XFFF8F8F8),
      body: SizedBox(
          height: size.height,
          width: double.infinity,
          child: Stack(alignment: Alignment.center, children: <Widget>[
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  // Note: Styles for TextSpans must be explicitly defined.
                  // Child text spans will inherit styles from parent
                  style: TextStyle(
                      fontSize: 25,
                      color: Color(0XFF19586A),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold),

                  children: <TextSpan>[
                    TextSpan(text: 'Biometric Location\n'),
                    TextSpan(
                        text: 'Authentication',
                        style: TextStyle(color: Color(0XFF19586A)))
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Image.asset('images/lock.png',
                height: size.height * 0.33,
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const LoginLayout();
                        },
                      ),
                    );
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: size.height * 0.075,
                        width: size.width * 0.8,
                        child: const DecoratedBox(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Color(0XFF19586A))),
                      ),
                      const Text("Login",
                          style: TextStyle(
                              fontSize: 20,
                              color: Color(0XFFF8F8F8),
                              fontWeight: FontWeight.normal))
                    ],
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const SignUpLayout();
                        },
                      ),
                    );
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: size.height * 0.075,
                        width: size.width * 0.8,
                        child: const DecoratedBox(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Color(0XFF19586A))),
                      ),
                      const Text("Sign Up",
                          style: TextStyle(
                              fontSize: 20,
                              color: Color(0XFFF8F8F8),
                              fontWeight: FontWeight.normal))
                    ],
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const MainLayout();
                        },
                      ),
                    );
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: size.height * 0.075,
                        width: size.width * 0.8,
                        child: const DecoratedBox(
                            decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                                color: Color(0XFF19586A))),
                      ),
                      const Text("Directly Main",
                          style: TextStyle(
                              fontSize: 20,
                              color: Color(0XFFF8F8F8),
                              fontWeight: FontWeight.normal))
                    ],
                  )),
            ])
          ])),
    );
  }
}
