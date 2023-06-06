import 'package:authentication/View/Main/EditProfile.dart';
import 'package:authentication/View/Main/MainLayout.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:local_auth/local_auth.dart';

import 'package:http/http.dart' as http;
import "dart:convert";
import 'dart:io';

class Settings extends StatelessWidget {
  Settings(
      {super.key,
      required this.userEmail});

  static const String _title = 'Flutter Code Sample';

  final String userEmail;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: SettingsPage(
          userEmail: userEmail),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.userEmail});

  final String userEmail;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool _fingerprint = false;
    bool _facescan = false;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(25, 88, 106, 1),
        centerTitle: true,
        title: const Text('Settings UI'),
        leading: Align(
          alignment: const Alignment(0, -0.2),
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return MainLayout(userEmail: 'userEmail');
                  },
                ),
              );
            },
            icon: const Icon(Icons.arrow_back_ios),
            color: const Color(0XFFF8F8F8),
          ),
        ),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('Fingerprint'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.fingerprint),
                title: const Text('Fingerprint'),
                value: const Text('Scan your fingerprint'),
                onPressed: (BuildContext context) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return MainLayout(userEmail: 'userEmail');
                      },
                    ),
                  );
                },
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Face Recognition'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.face_retouching_natural),
                title: const Text('Face Recognition'),
                value: const Text('Scan your face'),
                onPressed: (BuildContext context) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return MainLayout(userEmail: 'userEmail');
                      },
                    ),
                  );
                },
              ),
            ],
          ),
          SettingsSection(
            title: const Text('User-defined Location'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.person_outline),
                title: const Text('Add Mandatory Data'),
                onPressed: (BuildContext context) {
                  Mandatory('AddMandatory');
                },
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.person_outline),
                title: const Text('Delete Mandatory Data'),
                onPressed: (BuildContext context) {
                  Mandatory('DeleteMandatory');
                },
              ),

              SettingsTile.navigation(
                leading: const Icon(Icons.note_alt_sharp),
                title: const Text('If you add specific number of mandatory locations, the app cannot be opened in another locations'),

              ),
            ],
          ),
        ],
      ),
    );
  }

  void Mandatory(String buttonName) async {
    // Get current location

    // Prepare data
    Map<String, dynamic> data = {
      'Mandatory': buttonName,
      'userEmail' : widget.userEmail,
    };

    // Send data
    var url = 'http://your_django_server.com/api';  // Change to your Django server's API endpoint
    var response = await http.post(Uri.parse(url), body: json.encode(data), headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    });

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

}
