import 'dart:convert';

import 'package:authentication/View/Main/BiometricCheck.dart';
import 'package:authentication/View/Main/MainLayout.dart';
import 'package:authentication/View/Main/Settings.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Welcome/WelcomeLayout.dart';
import 'package:local_auth/local_auth.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';  //DateTime düzenlemek için

class LocationCheck extends StatelessWidget {
  LocationCheck(
      {super.key,
        required this.userEmail});

  static const String _title = 'Flutter Code Sample';

  final String userEmail;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: LocationLayout(
          userEmail: userEmail),
    );
  }
}


class LocationLayout extends StatefulWidget {
  LocationLayout({super.key, required this.userEmail});

  final String userEmail;

  @override
  State<LocationLayout> createState() => _LocationLayoutState();
}

class _LocationLayoutState extends State<LocationLayout> {
  String locationMessage = "Current Location";
  late double lat;
  late double preLat;
  late double long;
  late double preLong;
  late String preDate;
  late double population;
  late bool possible;
  DateTime date = DateTime.now();
  bool locationBool = false;

  Future<Position> _getCurrentLocation() async{
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled){
      return Future.error('Location service is disabled :/');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied){
        return Future.error('Location permission is denied :/');
      }
    }

    if(permission == LocationPermission.deniedForever){
      permission = await Geolocator.requestPermission();
      return Future.error('Location permission is permanently denied, location based authentication cannot be enabled :/');
    }

    //Konum izninde sıkıntı yok, doğrulama aşaması çalışabilir np
    return await Geolocator.getCurrentPosition();
  }

  //Her 10mtde longitude değiştiğinde konumu otomatik update ettirme, gerek yok çünkü bizde sadece girişte var
  /*
  void _liveLocation() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100 // Minimum distance(in meter) that device must move horizontally
    );

    Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position position) {
      lat = position.latitude.toString();
      long = position.longitude.toString();
      date = DateTime.now();
      setState(() {
        locationMessage = 'Latitude: $lat\n Longitude: $long\n Date: $date';
      });
    });
  }
  */

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              SizedBox(height: size.height * 0.05),
              Image.asset('images/location.png',
                height: size.height * 0.28,
              ),
              SizedBox(height: size.height * 0.05),
              Text(
                'Location Check',
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSerif(
                    fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Text(
                'Informations of last entrance',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: size.height * 0.04),
              Text(locationMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w400,
                ),),
              SizedBox(height: size.height * 0.15),
              //Burak
              //Burası biraz karıştı, normalde onPressed fonksiyonunu async yapıyorduk cevap beklediği için
              //Ama bu sefer içinde bir fonksiyon daha var, o yüzden içindeki fonksiyonu async yapmak zorundayız
              //onPressed fonksiyonunu async yapmadım 2 defa tepki vermesi gerekmesin diye, orayı değiştirebiliriz belki
              ElevatedButton(onPressed: () {
                _getCurrentLocation().then((value) async {
                  locationBool = true; //Burada konum doğrulama yapmadan biometric'e geçmesini önledim
                  lat = value.latitude;
                  long = value.longitude;
                  String dateTime = DateFormat('yyyy-MM-dd – kk:mm').format(date);

                  final url = '';

                  final response = await http.post(
                    Uri.parse(url),
                    headers: <String, String>{
                      'Content-Type':
                      'application/json; charset=UTF-8',
                    },
                    //Burak
                    //Burada konum ve zaman bilgilerini yolluyorum, aşağıdaki commente de bak
                    body: json.encode(
                        {"latitude": lat,
                          "longitude": long,
                          "date": dateTime,
                          "email": widget.userEmail, //Bu böyle gönderiliyor diye biliyorum, değiştir
                        }
                    ),
                  );

                  //await bitti, response değerini aldık, işleme koyabilirim

                  final decodedResponse = jsonDecode(response.body);
                  print(decodedResponse[0]); //Doğru elementler geldi mi kontrol ediyorum print ile

                  //Burada hangi değerlerin döndüğü yazıyor
                  //Bu değerler döndükten sonra gerisini flutterda hallettim ben
                  preDate = decodedResponse[0]["previousDate"];
                  preLat = decodedResponse[0]["previousLatitude"];
                  preLong = decodedResponse[0]["previousLongitude"];
                  population = decodedResponse[0]["population"];
                  possible = decodedResponse[0]["possible"];

                  setState(() {
                    locationMessage = 'Current Location: Latitude: $lat  Longitude: $long Date: $date\n';
                    locationMessage += 'Last Location: Latitude: $preLat  Longitude: $preLong Date: $preDate';

                    //Canlı konum takibi yaptırabilirim, ama kapatıyorum bizim uygulamada şimdilik unnecessary
                    //_liveLocation();
                  });
                });
              },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0XFF19586A),
                  minimumSize: Size(size.height * 0.28, size.height * 0.08),
                  // Background color
                ),
                child: const Text("Get Current Location",
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0XFFF8F8F8),
                      fontWeight: FontWeight.normal),),
              ),
              SizedBox(height: size.height * 0.02),
              TextButton(
                  onPressed: () {
                    //Doğrulama yaptıysa biometric doğrulama kısmına atıyor
                    if (locationBool && possible) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            //Burada population'u backendten alıp koyacaksın
                            //Şu an veri yok diye rastgele bir sayı girildi
                            //DÜZELTİLECEK
                            return BiometricCheck(userEmail: widget.userEmail, latitude: lat, longitude: long, population: 55000*9);
                          },
                        ),
                      );
                    }
                    //Doğrulama yapmadıysa doğrulama yapması için pop-up çıkarıyor.
                    else if (!locationBool){
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Location Authentication Error', textAlign: TextAlign.center,),
                          content: const Text('You can login after location check and authentication is done. Use the button in the above.', textAlign: TextAlign.center,),
                        ),);
                    }
                    else{
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Location Authentication Error', textAlign: TextAlign.center,),
                          content: const Text('It is not possible to rach that far that quickly', textAlign: TextAlign.center,),
                        ),);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return MainLayout();},
                        ),
                      );
                    }
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: size.height * 0.08,
                        width: size.width * 0.6,
                        child: const DecoratedBox(
                            decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(4)),
                                color: Color(0XFF19586A))),
                      ),
                      const Text("Biometric Authentication",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color(0XFFF8F8F8),
                              fontWeight: FontWeight.normal))
                    ],
                  )),

            ],
          ),
        ),
      ),
    );
  }
}



