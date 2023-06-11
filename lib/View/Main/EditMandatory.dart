import 'dart:async';
import 'package:authentication/View/Main/Settings.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';


class EditMandatory extends StatefulWidget {
  const EditMandatory({Key? key, required this.userEmail}) : super(key: key);
  final String userEmail;

  @override
  State<EditMandatory> createState() => _EditMandatoryState();
}

class _EditMandatoryState extends State<EditMandatory> {
  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(41.105000, 29.025000);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    LatLng? _selectedLocation;
    Set<Marker> _markers = {};

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(25, 88, 106, 1),
          centerTitle: true,
          title: const Text('Mandatory Location Update'),
          leading: Align(
            alignment: const Alignment(0, -0.2),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SettingsPage(userEmail: 'userEmail');
                    },
                  ),
                );
              },
              icon: const Icon(Icons.arrow_back_ios),
              color: const Color(0XFFF8F8F8),
            ),
          ),
        ),
        body: SafeArea(
          child: Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                SizedBox(height: size.height * 0.02),
                Container(
                  height: size.height * 0.6,
                  width: size.width * 0.9,
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: 15.0,
                    ),
                    markers: _markers,
                    onTap: (LatLng location) {
                      setState(() {
                        _markers.clear();
                        _markers.add(
                          Marker(
                            markerId: MarkerId('selected_location'),
                            position: location,
                            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                            infoWindow: InfoWindow(
                              title: 'Location',
                              snippet: 'My Custom Subtitle',
                            ),
                          ),
                        );
                        _selectedLocation = location;
                        print(location);
                      });
                    },
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                Builder(
                  builder: (BuildContext context) {
                    return ElevatedButton(
                      onPressed: () async {
                        print(_selectedLocation);
                        if (_selectedLocation != null) {
                          print("Not null");
                          var response = await http.post(
                            Uri.parse('http://your-server.com/update-location'), // replace with your server URL
                            body: jsonEncode({
                              'latitude': _selectedLocation!.latitude,
                              'longitude': _selectedLocation!.longitude,
                            }),
                          );
                          if (response.statusCode == 200) {
                            print('Location updated');
                          } else {
                            print('Failed to update location');
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please select a location on the map.'),
                            ),
                          );
                        }
                      },
                      child: Text('Add Location'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0XFF19586A),
                        minimumSize: Size(size.height * 0.28, size.height * 0.08),
                      ),
                    );
                  },
                ),
                SizedBox(height: size.height * 0.01),
                ElevatedButton(
                  onPressed: () async {
                    if (_selectedLocation != null) {
                      var response = await http.post(
                        Uri.parse('http://your-server.com/update-location'), // replace with your server URL
                        body: jsonEncode({
                          'latitude': _selectedLocation!.latitude,
                          'longitude': _selectedLocation!.longitude,
                        }),
                      );
                      if (response.statusCode == 200) {
                        print('Location updated');
                      } else {
                        print('Failed to update location');
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please select a location on the map.'),
                        ),
                      );
                    }
                  },
                  child: Text('Delete Location'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0XFF19586A),
                    minimumSize: Size(size.height * 0.28, size.height * 0.08),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}