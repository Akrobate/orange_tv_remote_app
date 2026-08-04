import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orange_tv_remote_app/pages/remote_controller_screen.dart';
import 'package:orange_tv_remote_app/pages/remote_settings_screen.dart';
import 'package:orange_tv_remote_app/services/local_app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app boots on the remote controller screen', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final settings = LocalAppSettings();
    settings.resetForTest();
    await settings.init();

    await tester.pumpWidget(
      MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (_) => RemoteControllerScreen(),
          '/settings_screen': (_) => RemoteSettingsScreen(),
        },
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('OrangeTV télécommande'), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);
  });
}
