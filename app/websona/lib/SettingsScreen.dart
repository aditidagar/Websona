import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:websona/Profile.dart';
import 'package:websona/SocialLinks.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return SettingsList(
      sections: [
        SettingsSection(
          title: 'Profile',
          tiles: [
            SettingsTile(
              title: 'Edit My Profile',
              leading: Icon(Icons.person),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfilePage()));
              },
            ),
          ],
        ),
        SettingsSection(
          title: 'Misc',
          tiles: [
            SettingsTile(
              title: 'Terms of Service',
              leading: Icon(Icons.article),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => editsurvey()));
                print("Terms of Service");
              },
            ),
            SettingsTile(
              title: 'Privacy',
              leading: Icon(Icons.privacy_tip),
              onTap: () {
                print("Privacy");
              },
            ),
            SettingsTile(
              title: 'Licenses',
              leading: Icon(Icons.analytics),
            )
          ],
        )
      ],
    );
  }
}
