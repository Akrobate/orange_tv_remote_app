import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orange_tv_remote_app/pages/remote_settings_screen.dart';
import 'package:orange_tv_remote_app/services/local_app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _prepareSettings({
  int remoteType = LocalAppSettings.ADVANCED_REMOTE_CONTROLLER,
  int theme = LocalAppSettings.DARK_THEME,
  String deviceIp = '192.168.1.50',
}) async {
  SharedPreferences.setMockInitialValues({
    'typeRemoteSelected': remoteType,
    'typeRemoteThemeSelected': theme,
    'deviceIp': deviceIp,
  });
  final settings = LocalAppSettings();
  settings.resetForTest();
  await settings.init();
}

Widget _buildSettingsApp() {
  return MaterialApp(
    home: RemoteSettingsScreen(),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RemoteSettingsScreen', () {
    testWidgets('shows saved IP and current selections', (tester) async {
      await _prepareSettings(
        remoteType: LocalAppSettings.SIMPLE_REMOTE_CONTROLLER,
        theme: LocalAppSettings.CLEAR_THEME,
        deviceIp: '10.0.0.8',
      );

      await tester.pumpWidget(_buildSettingsApp());
      await tester.pumpAndSettle();

      expect(find.text('Paramètres'), findsOneWidget);
      expect(find.text('10.0.0.8'), findsOneWidget);
      expect(find.text('Simplifiée'), findsOneWidget);
      expect(find.text('Avancée'), findsOneWidget);
      expect(find.text('Sombre'), findsOneWidget);
      expect(find.text('Clair'), findsOneWidget);
      expect(find.text('Recherche automatique'), findsOneWidget);
    });

    testWidgets('persists remote type when tapping Simplifiée', (tester) async {
      await _prepareSettings();

      await tester.pumpWidget(_buildSettingsApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Simplifiée'));
      await tester.pumpAndSettle();

      expect(
        LocalAppSettings().getTypeRemoteSelected(),
        LocalAppSettings.SIMPLE_REMOTE_CONTROLLER,
      );
    });

    testWidgets('persists theme when tapping Clair', (tester) async {
      await _prepareSettings();

      await tester.pumpWidget(_buildSettingsApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Clair'));
      await tester.pumpAndSettle();

      expect(
        LocalAppSettings().getTypeRemoteThemeSelected(),
        LocalAppSettings.CLEAR_THEME,
      );
    });

    testWidgets('persists theme when tapping Sombre', (tester) async {
      await _prepareSettings(theme: LocalAppSettings.CLEAR_THEME);

      await tester.pumpWidget(_buildSettingsApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sombre'));
      await tester.pumpAndSettle();

      expect(
        LocalAppSettings().getTypeRemoteThemeSelected(),
        LocalAppSettings.DARK_THEME,
      );
    });

    testWidgets('saves IP on field submission', (tester) async {
      await _prepareSettings(deviceIp: '');

      await tester.pumpWidget(_buildSettingsApp());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '192.168.1.99');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(LocalAppSettings().getDeviceIp(), '192.168.1.99');
    });
  });
}
