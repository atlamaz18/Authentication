import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Welcome/WelcomeLayout.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // big logo
            SizedBox(height: size.height * 0.1),
            Image.asset('images/main.png',
              height: size.height * 0.4,
            ),
            SizedBox(height: size.height * 0.03),
            Text(
              'We ensure that you\'re always secure',
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSerif(
                  fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.01),
            // groceree gives you fresh vegetables and fruits
            Text(
              'Thanks for believing us',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                fontWeight: FontWeight.w400,
              ),
            ),

            SizedBox(height: size.height * 0.08),

            TextButton(
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
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: size.height * 0.1,
                      width: size.width * 0.5,
                      child: const DecoratedBox(
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(10)),
                              color: Color(0XFF19586A))),
                    ),
                    const Text("Personal Data Settings",
                        style: TextStyle(
                            fontSize: 16,
                            color: Color(0XFFF8F8F8),
                            fontWeight: FontWeight.normal))
                  ],
                ))
          ],
        ),
      ),
    );
  }
}