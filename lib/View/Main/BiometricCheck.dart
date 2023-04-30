import 'package:authentication/View/Main/LocationCheck.dart';
import 'package:authentication/View/Main/MainLayout.dart';
import 'package:authentication/View/Main/Settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Welcome/WelcomeLayout.dart';
import 'package:local_auth/local_auth.dart';

class BiometricCheck extends StatelessWidget {
  BiometricCheck(
      {super.key,
        required this.userEmail,
        required this.latitude,
        required this.longitude,
        required this.population});

  static const String _title = 'Flutter Code Sample';

  final String userEmail;
  final double latitude;
  final double longitude;
  final double population;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: BiometricLayout(
        userEmail: userEmail,
        latitude: latitude,
        longitude: longitude,
        population: longitude,
      ),
    );
  }
}


class BiometricLayout extends StatefulWidget {
  BiometricLayout({super.key,
    required this.userEmail,
    required this.latitude,
    required this.longitude,
    required this.population});

  final String userEmail;
  final double latitude;
  final double longitude;
  final double population;


  @override
  State<BiometricLayout> createState() => _BiometricLayoutState();
}

class _BiometricLayoutState extends State<BiometricLayout> {

  late final LocalAuthentication auth;
  bool _supportState = false;
  late String populationString;

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then((bool isSupported) => setState(() {
      _supportState = isSupported;
    }),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if(widget.population / 9 > 55000) populationString = 'it is not recommended';
    else populationString = 'There is not any problem';
    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              SizedBox(height: size.height * 0.1),
              if(_supportState)
                const Text('This device is supported for biometric authentication.')
              else
                const Text('This device is not supported for biometric authentication.'),
              SizedBox(height: size.height * 0.05),
              Padding(
               padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 45.0),
                child: Text('The population per meter square is ${widget.population / 9}. ${populationString} to use face scan.', textAlign: TextAlign.center,),
              ),

              //Aşağıdaki commentler hangi biometric türeri available onu gösteriyor
              //Bizim cihazda ikisi de var np, o yüzden bu butonu kaldırdım
              //ElevatedButton(onPressed: _getAvailableBiometrics, child: const Text('Get Available Biometrics')),
              SizedBox(height: size.height * 0.5),
              ElevatedButton(onPressed: _authenticate,
                child: Text('Authenticate'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0XFF19586A),
                  minimumSize: Size(size.height * 0.28, size.height * 0.08),
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }

  Future<void> _authenticate() async {
    try{
      bool authenticated = await auth.authenticate(
        localizedReason: 'Biometrik doğrulama yap seri',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      print("Authenticated: $authenticated");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return MainLayout();
          },
        ),
      );
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> _getAvailableBiometrics() async{
    List<BiometricType> availableBiometrics =
      await auth.getAvailableBiometrics();
    
    print('List of available biometrics : $availableBiometrics');

    if(!mounted){
      return;
    }
    
}

}
