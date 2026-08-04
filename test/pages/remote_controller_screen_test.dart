import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orange_tv_remote_app/pages/remote_controller_screen.dart';
import 'package:orange_tv_remote_app/pages/remote_settings_screen.dart';
import 'package:orange_tv_remote_app/remote_controller_widgets/advanced_remote_controller.dart';
import 'package:orange_tv_remote_app/remote_controller_widgets/simple_remote_controller.dart';
import 'package:orange_tv_remote_app/services/local_app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _prepareSettings({
  int remoteType = LocalAppSettings.ADVANCED_REMOTE_CONTROLLER,
  int theme = LocalAppSettings.DARK_THEME,
  String deviceIp = '',
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

Widget _buildApp() {
  return MaterialApp(
    routes: {
      '/': (_) => RemoteControllerScreen(),
      '/settings_screen': (_) => RemoteSettingsScreen(),
    },
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RemoteControllerScreen', () {
    testWidgets('shows advanced remote by default', (tester) async {
      await _prepareSettings();

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.text('OrangeTV télécommande'), findsOneWidget);
      expect(find.byType(AdvancedRemoteController), findsOneWidget);
      expect(find.byType(SimpleRemoteController), findsNothing);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('shows simple remote when configured', (tester) async {
      await _prepareSettings(
        remoteType: LocalAppSettings.SIMPLE_REMOTE_CONTROLLER,
      );

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(SimpleRemoteController), findsOneWidget);
      expect(find.byType(AdvancedRemoteController), findsNothing);
    });

    testWidgets('opens settings and applies theme on return', (tester) async {
      await _prepareSettings();

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      expect(find.text('Paramètres'), findsOneWidget);

      await tester.tap(find.text('Clair'));
      await tester.pumpAndSettle();

      await tester.pageBack();
      await tester.pumpAndSettle();

      expect(find.text('OrangeTV télécommande'), findsOneWidget);
      expect(
        LocalAppSettings().getTypeRemoteThemeSelected(),
        LocalAppSettings.CLEAR_THEME,
      );
    });

    testWidgets('applies simple remote choice after leaving settings',
        (tester) async {
      await _prepareSettings();

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();
      expect(find.byType(AdvancedRemoteController), findsOneWidget);

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Simplifiée'));
      await tester.pumpAndSettle();

      await tester.pageBack();
      await tester.pumpAndSettle();

      expect(find.byType(SimpleRemoteController), findsOneWidget);
      expect(
        LocalAppSettings().getTypeRemoteSelected(),
        LocalAppSettings.SIMPLE_REMOTE_CONTROLLER,
      );
    });
  });
}
