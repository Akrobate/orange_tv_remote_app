import 'package:flutter/material.dart';
import 'package:orange_tv_remote_app/remote_controller_widgets/advanced_remote_controller.dart';
import 'package:orange_tv_remote_app/remote_controller_widgets/simple_remote_controller.dart';
import 'package:orange_tv_remote_app/services/local_app_settings.dart';
import 'package:orange_tv_remote_app/services/device_http_client.dart';
import 'package:orange_tv_remote_app/themes/theme_abstract.dart';
import 'package:orange_tv_remote_app/themes/themes_manager.dart';

class RemoteControllerScreen extends StatefulWidget {

  @override
  _RemoteControllerScreenState createState() => _RemoteControllerScreenState();
}

class _RemoteControllerScreenState extends State<RemoteControllerScreen> {

  final LocalAppSettings appSettings = LocalAppSettings();
  final DeviceHttpClient device = DeviceHttpClient();
  late ThemeAbstract theme;
  late Color appBarBackgroundColor;
  late Color backgroundColor;
  int templateType = 1;

  initState() {
    super.initState();
    loadAppSettings();
  }

  void loadAppSettings() async {
    await appSettings.init();
    setState(() {
      templateType = appSettings.getTypeRemoteSelected();
    });
  }

  @override
  Widget build(BuildContext context) {

    templateType = appSettings.getTypeRemoteSelected();
    device.setDeviceIp(appSettings.getDeviceIp());

    theme = ThemeManager.getTheme(appSettings.getTypeRemoteThemeSelected());
    appBarBackgroundColor = theme.getAppBarBackgroundColor();
    backgroundColor = theme.getRemoteControllerBackgroundColor();

    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text('OrangeTV télécommande'),
          centerTitle: true,
          backgroundColor: appBarBackgroundColor,
          foregroundColor: Colors.white,
          elevation: 0.0,
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () async {
                await Navigator.pushNamed(context, '/settings_screen');
                setState(() {});
              },
            ),
          ],
        ),
        body: SafeArea(
          child: templateType == 1 ? SimpleRemoteController(device: device, theme: theme) : AdvancedRemoteController(device: device, theme: theme),
        ),
    );
  }
}
