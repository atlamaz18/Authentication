import 'dart:async';
import 'package:authentication/View/Main/Settings.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
  List<Marker> _dynamicMarkers = [];

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
    final baseUrl = dotenv.env['BASE_URL'];
    final finalurl = (baseUrl != null ? baseUrl : 'http://127.0.0.1') + '/get_mandatory_locations/';
    final url = Uri.parse(finalurl);
    final body = jsonEncode({'email': widget.userEmail});
    final headers = {'Content-Type': 'application/json'};

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final List<dynamic> locations = jsonDecode(response.body);
        _addMarkers(locations); // Add markers for each location received from the backend
      } else {
        print('Failed to fetch locations. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching locations: $e');
    }
  }

  void _addMarkers(List<dynamic> locations) {
    for (int i = 0; i < locations.length; i++) {
      var location = locations[i];
      final LatLng latLng = LatLng(location['latitude'], location['longitude']);
      final marker = Marker(
        markerId: MarkerId('Marker_$i'),
        position: latLng,
        infoWindow: InfoWindow(
          title: 'Location ${i+1}',  // you can replace this with `Location ${location['id']}` if your location objects have 'id' property
        ),
      );
      _markers.add(marker);
      _dynamicMarkers.add(marker);
    }
    setState(() {});  // This will cause the map to rebuild and show the newly added markers
}

  void _deleteSelectedMarker(double? latitude, double? longitude) async {
    if (latitude != null && longitude != null) {
      final threshold = 0.000001; // Adjust the threshold value as needed

      final selectedLocation = LatLng(latitude, longitude);
      bool markerFound = false;

      for (final marker in _markers) {
        if ((marker.position.latitude - selectedLocation.latitude).abs() < threshold &&
            (marker.position.longitude - selectedLocation.longitude).abs() < threshold) {
          final baseUrl = dotenv.env['BASE_URL'];
          final finalurl = (baseUrl != null ? baseUrl : 'http://127.0.0.1') + '/delete_mandatory_location/';

          final response = await http.post(
            Uri.parse(finalurl),
            body: jsonEncode({
              'email': widget.userEmail,
              'latitude': latitude,
              'longitude': longitude,
            }),
          );

          if (response.statusCode == 200) {
            _markers.remove(marker);
            _dynamicMarkers.remove(marker);
            _selectedLocation = null;
            setState(() {
              _dynamicMarkers = _dynamicMarkers.sublist(0, _dynamicMarkers.length - 1);
            });
            markerFound = true;
            break;
          } else {
            print('Failed to delete location. Status code: ${response.statusCode}');
          }
        }
      }

      if (!markerFound) {
        print('Matching marker not found');
      }
    }
  }



  Future<void> _addLocation() async {
  if (_selectedLocation != null) {
    final latitude = _selectedLocation!.latitude;
    final longitude = _selectedLocation!.longitude;
    final baseUrl = dotenv.env['BASE_URL'];
    final finalurl = (baseUrl != null ? baseUrl : 'http://127.0.0.1') + '/add_mandatory_location/';
    final response = await http.post(
      Uri.parse(finalurl),
      body: jsonEncode({
        'email': widget.userEmail,
        'latitude': latitude,
        'longitude': longitude,
      }),
    );

    if (response.statusCode == 200) {
      final markerId = MarkerId('new_location_${_dynamicMarkers.length + 1}');
      final marker = Marker(
        markerId: markerId,
        position: _selectedLocation!,
        infoWindow: InfoWindow(
          title: 'New Location',
        ),
      );
      _markers.add(marker);
      _dynamicMarkers.add(marker);
      setState(() {});
    } else {
      print('Failed to add location. Status code: ${response.statusCode}');
    }
  }
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
                      return SettingsPage(userEmail: widget.userEmail);
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
                  onPressed: _addLocation,
                  child: Text('Add Location'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0XFF19586A),
                    minimumSize: Size(size.height * 0.28, size.height * 0.08),
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                ElevatedButton(
                  onPressed: () {
                    if (_selectedLocation != null) {
                      _deleteSelectedMarker(_selectedLocation!.latitude, _selectedLocation!.longitude);
                    }
                    else{
                      print("ANIL, konum seçinde Null gönderiyor neden bilmiyorum");
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





