import 'package:authentication/View/Main/LocationCheck.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Welcome/WelcomeLayout.dart';
import '../SignUp/SignUpLayout.dart';



TextEditingController passwordController = TextEditingController();
TextEditingController emailController = TextEditingController();

class LoginLayout extends StatefulWidget {
  const LoginLayout({Key? key}) : super(key: key);

  @override
  State<LoginLayout> createState() => _LoginLayoutState();
}

class _LoginLayoutState extends State<LoginLayout> {
  static final formGlobalKey1 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Form(
              key: formGlobalKey1,
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
                  SizedBox(height: size.height * 0.03),
                  Image.asset('images/lock_login.png',
                    height: size.height * 0.2,
                  ),
                  SizedBox(height: size.height * 0.055),
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
                              //Burada validate() fonksiyonu login infolarını doğru alıp almadığımı sorguluyor.
                              //Eğer doğru almış ise o verileri sana gönderiyor, veriler decodedResponse[0] gibi array içinde taşınıyor
                              if (formGlobalKey1.currentState!.validate()) {
                                //Burada url kısmına django çalışınca terminalde yazan url gelecek
                                //Ben uygulama çalışsın diye comment attım bilerek

                                final baseUrl = dotenv.env['BASE_URL'];
                                final url = (baseUrl != null ? baseUrl : 'http://127.0.0.1') + '/login/';

                                final response = await http.post(
                                    Uri.parse(url),
                                  headers: <String, String>{
                                    'Content-Type':
                                    'application/json; charset=UTF-8',
                                  },
                                    body: json.encode(
                                        {"email": emailController.text,
                                        "password": passwordController.text},
                                    ),
                                );
                                //Eğer gönderim işlemi başarılı ise success code olarak 200 alıyoruz, diğer sayfaya geçebiliriz
                                if(response.statusCode == 200){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return LocationCheck(userEmail: emailController.text);
                                      },
                                    ),
                                  );
                                }
                                //Eğer validation başarısızsa(şu an URI içinde url yok o yüzden ERROR alıyoruz)
                                //Bu durumda da hata pop-up'ı verecek kanka şifren hatalı diye
                                //Ha bizde vermiyor çünkü herhangi bir validation yok, gönderimde patlıyoruz daha
                                else{
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(40)),
                                        elevation: 16,
                                        child: Container(
                                          child: ListView(
                                            shrinkWrap: true,
                                            children: <Widget>[
                                              SizedBox(height: 20),
                                              Center(
                                                  child: Text(response.body),
                                              ),
                                              SizedBox(height: 20),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                              }
                            },
                            child: const Text("Login",
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
                          const TextSpan(text: "Don't have an account?\n"),
                          TextSpan(
                              text: 'Sign Up',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return const SignUpLayout();
                                      },
                                    ),
                                  );
                                }),
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
          } else if (sValue.length < 2) {
            return 'Password is shorter than 8 characters.';
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