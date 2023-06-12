import 'package:authentication/View/Main/LocationCheck.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../Login/LoginLayout.dart';
import '../Welcome/WelcomeLayout.dart';

TextEditingController passwordController = TextEditingController();
TextEditingController emailController = TextEditingController();

class SignUpLayout extends StatefulWidget {
  const SignUpLayout({Key? key}) : super(key: key);

  @override
  State<SignUpLayout> createState() => _SignUpLayoutState();
}

class _SignUpLayoutState extends State<SignUpLayout> {
  static final formGlobalKey2 = GlobalKey<FormState>();
  bool obsPasswordAgain = true;
  void ToggleObsPasswordAgain() {
    setState(() {
      obsPasswordAgain = !obsPasswordAgain;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Form(
              key: formGlobalKey2,
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.035),
                  Align(
                    alignment: const Alignment(-0.9, -0.2),
                    child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const WelcomeLayout();
                              },
                            ),
                          );
                        },
                        icon: const Icon(Icons.arrow_back_ios),
                        color: const Color.fromRGBO(25, 88, 106, 1),
                        iconSize: 30),
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      // Note: Styles for TextSpans must be explicitly defined.
                      // Child text spans will inherit styles from parent
                      style: TextStyle(
                          fontSize: 40,
                          color: Color(0XFF19586A),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold),

                      children: <TextSpan>[
                        TextSpan(text: 'Welcome\n'),
                        TextSpan(
                            text: 'The only address to keep your information secure',
                            style: TextStyle(color: Color(0XFF19586A),
                            fontSize: 15,
                            fontWeight: FontWeight.w400),)
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.060),
                  const Align(
                    alignment: Alignment(-0.76, 0),
                    child: Text("E-mail",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 15.5,
                            fontFamily: 'Poppins',
                            color: Color.fromRGBO(25, 88, 106, 1),
                            fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: size.height * 0.015),
                  SizedBox(
                    height: size.height * 0.1,
                    width: size.width * 0.8,
                    child: TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (sValue) {
                        if (sValue == null || sValue.isEmpty) {
                          return 'Please enter a meaningful text';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: "abc@itu.edu.tr"),
                    ),
                  ),
                  SizedBox(height: size.height * 0.015),
                  const Align(
                    alignment: Alignment(-0.76, 0),
                    child: Text("Password",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 15.5,
                            color: Color.fromRGBO(25, 88, 106, 1),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: size.height * 0.015),
                  SizedBox(
                      height: size.height * 0.1,
                      width: size.width * 0.8,
                      child: const PasswordField()),
                  SizedBox(height: size.height * 0.015),
                  const Align(
                    alignment: Alignment(-0.76, 0),
                    child: Text("Password Again",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 15.5,
                            fontFamily: 'Poppins',
                            color: Color.fromRGBO(25, 88, 106, 1),
                            fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: size.height * 0.015),
                  SizedBox(
                    height: size.height * 0.1,
                    width: size.width * 0.8,
                    child: TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: obsPasswordAgain,
                      validator: (sValue) {
                        if (sValue != passwordController.text) {
                          return 'Your passwords are not the same, check please';
                        }
                        return null;
                      },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            hintText: "********",
                            suffixIcon: IconButton(
                                onPressed: ToggleObsPasswordAgain,
                                icon: Icon(obsPasswordAgain
                                    ? Icons.visibility_off
                                    : Icons.visibility)))
                    ),
                  ),
                  SizedBox(height: size.height * 0.015),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: size.height * 0.075,
                        width: size.width * 0.8,
                        child: const DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(10),),
                            color: Color.fromRGBO(25, 88, 106, 1),),),
                      ),
                      SizedBox(
                        height: size.height * 0.075,
                        width: size.width * 0.8,
                        child: TextButton(
                            onPressed: () async {
                              // Validate returns true if the form is valid, or false otherwise.

                              //Burak
                              //Kanka burası login gibi aynı, şifre ve email verisi var, onları alıp db'ye eklemek gerekiyor.
                              //Aynı zamanda MandatoryLogin = 0 olacak çünkü ilk defa üye girişi yapılıyor daha konum atamadı
                              //Konum ve zaman konrolü için ayrı bir page açıp orada göndericem o dataları, boşuna tek sayfaya sıkışmasın
                              //
                              if (formGlobalKey2.currentState!.validate()) {
                                //Burada yine url gerekiyor çalışınca terminalde yazan
                                final baseUrl = dotenv.env['BASE_URL'];
                                final url = (baseUrl != null ? baseUrl : 'http://127.0.0.1') + '/create_user/';
                                print(url);
                                final response = await http.post(
                                  Uri.parse(url),
                                  headers: <String, String>{
                                    'Content-Type':
                                    'application/json; charset=UTF-8',
                                  },
                                  body: json.encode(<String, String>
                                    {"email": emailController.text,
                                      "password": passwordController.text},
                                  ),
                                );

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return LocationCheck(userEmail: emailController.text);
                                      },
                                    ),
                                  );
                              }
                            },
                            child: const Text("Sign Up",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal))),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.02),
                  Align(
                    alignment: const Alignment(-0.7, 0),
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        style: const TextStyle(
                            fontSize: 15,
                            color: Color.fromRGBO(25, 88, 106, 1),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500),
                        children: <TextSpan>[
                          const TextSpan(text: "Already have an account?\n"),
                          TextSpan(
                              text: 'Login',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return const LoginLayout();
                                      },
                                    ),
                                  );
                                })
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


class PasswordField extends StatefulWidget {
  const PasswordField({super.key});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool obsecurePassword = true;
  void ToggleObsecure() {
    setState(() {
      obsecurePassword = !obsecurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: passwordController,
        keyboardType: TextInputType.visiblePassword,
        obscureText: obsecurePassword,
        //validator: (val) => (val!.length< 8 || val.isEmpty) ? 'Please enter a meaningful text' : null,
        validator: (sValue) {
          if (sValue == null || sValue.isEmpty) {
            return 'Please enter a meaningful text';
          } else if (sValue.length < 4) {
            return 'Password is shorter than 4 characters.';
          }
          return null;
        },
        decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            hintText: "********",
            suffixIcon: IconButton(
                onPressed: ToggleObsecure,
                icon: Icon(obsecurePassword
                    ? Icons.visibility_off
                    : Icons.visibility))));
  }
}