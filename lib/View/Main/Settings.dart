import 'package:authentication/View/Main/EditProfile.dart';
import 'package:authentication/View/Main/MainLayout.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:local_auth/local_auth.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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
                      return const MainLayout();
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
                        return const MainLayout();
                      },
                    ),
                  );
                },
              ),
              SettingsTile.switchTile(
                onToggle: (bool value) {
                  setState(() {
                    _fingerprint = value;
                  });
                },
                initialValue: false,
                title: const Text('Fingerprint scan'),
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
                        return const MainLayout();
                      },
                    ),
                  );
                },
              ),
              SettingsTile.switchTile(
                onToggle: (bool value) {
                  setState(() {
                    _facescan = value;
                  });
                },
                initialValue: false,
                title: const Text('Face recognition '),
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Personal Data'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.person_outline),
                title: const Text('Edit Personal Data'),
                value: const Text('Email - password - name'),
                onPressed: (BuildContext context) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const EditProfile();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
