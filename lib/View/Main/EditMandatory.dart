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
  static const LatLng _center = const LatLng(41.105000, 29.025000);

  final List<Marker> _list = const [
    Marker(
      markerId: MarkerId('1'),
      position: _center,
      infoWindow: InfoWindow(
        title: 'Current Location',
      ),
    ),
    Marker(
      markerId: MarkerId('2'),
      position: LatLng(41, 29),
      infoWindow: InfoWindow(
        title: 'Mandatory Location',
      ),
    ),
  ];

  Completer<GoogleMapController> _controller = Completer();
  LatLng? _selectedLocation;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _markers = Set<Marker>.from(_list);
    _fetchLocations(); // Fetch location data from the backend
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  Future<void> _fetchLocations() async {
    // Simulating API call to retrieve location data from the backend
    final response = await http.get(Uri.parse('ANIL'));
    if (response.statusCode == 200) {
      final List<dynamic> locations = jsonDecode(response.body);
      _addMarkers(locations); // Add markers for each location received from the backend
    } else {
      print('Failed to fetch locations. Status code: ${response.statusCode}');
    }
  }

  void _addMarkers(List<dynamic> locations) {
    for (var location in locations) {
      final LatLng latLng = LatLng(location['latitude'], location['longitude']);
      final marker = Marker(
        markerId: MarkerId(location['id'].toString()),
        position: latLng,
        infoWindow: InfoWindow(
          title: 'Location ${location['id']}',
        ),
      );
      _markers.add(marker);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
                        _selectedLocation = location;
                        _markers.add(
                          Marker(
                            markerId: MarkerId('selected_location'),
                            position: location,
                            infoWindow: InfoWindow(
                              title: 'Selected Location',
                            ),
                          ),
                        );
                      });
                    },
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                ElevatedButton(
                  onPressed: () {
                    if (_selectedLocation != null) {
                      print('Selected Location: ${_selectedLocation!.latitude}, ${_selectedLocation!.longitude}');
                    }
                  },
                  child: Text('Add Location'),
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