import 'package:flutter/material.dart';
import 'package:orange_tv_remote_app/pages/remote_controller_screen.dart';
import 'package:orange_tv_remote_app/pages/remote_settings_screen.dart';
import 'package:orange_tv_remote_app/services/local_app_settings.dart';
import 'package:flutter/services.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  const bool debug_mode = false;

  // Load persisted settings before building any screen so the UI never reads
  // uninitialized values.
  await LocalAppSettings().init();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MaterialApp(
      initialRoute: '/',
      debugShowCheckedModeBanner: debug_mode,
      routes: {
        '/': (context) => RemoteControllerScreen(),
        '/controller_screen': (context) => RemoteControllerScreen(),
        '/settings_screen': (context) => RemoteSettingsScreen(),
      }
  ));
}
