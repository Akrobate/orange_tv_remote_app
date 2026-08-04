import 'package:flutter_test/flutter_test.dart';
import 'package:orange_tv_remote_app/services/local_app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late LocalAppSettings settings;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    settings = LocalAppSettings();
    settings.resetForTest();
    await settings.init();
  });

  group('LocalAppSettings', () {
    test('is a singleton', () {
      expect(identical(LocalAppSettings(), LocalAppSettings()), isTrue);
    });

    test('loads defaults when preferences are empty', () {
      expect(settings.getDeviceIp(), '');
      expect(
        settings.getTypeRemoteSelected(),
        LocalAppSettings.DEFAULT_REMOTE_CONTROLLER,
      );
      expect(
        settings.getTypeRemoteThemeSelected(),
        LocalAppSettings.DEFAULT_THEME,
      );
      expect(settings.getDeviceFound(), isFalse);
      expect(settings.getFirstAppLaunch(), isTrue);
    });

    test('persists and reloads device IP', () async {
      settings.setDeviceIp('192.168.1.20');

      final reloaded = LocalAppSettings();
      reloaded.resetForTest();
      await reloaded.init();

      expect(reloaded.getDeviceIp(), '192.168.1.20');
    });

    test('persists remote type and theme', () async {
      settings.setTypeRemoteSelected(LocalAppSettings.SIMPLE_REMOTE_CONTROLLER);
      settings.setTypeRemoteThemeSelected(LocalAppSettings.CLEAR_THEME);

      final reloaded = LocalAppSettings();
      reloaded.resetForTest();
      await reloaded.init();

      expect(
        reloaded.getTypeRemoteSelected(),
        LocalAppSettings.SIMPLE_REMOTE_CONTROLLER,
      );
      expect(
        reloaded.getTypeRemoteThemeSelected(),
        LocalAppSettings.CLEAR_THEME,
      );
    });

    test('persists deviceFound and firstAppLaunch flags', () async {
      settings.setDeviceFound(true);
      settings.setFirstAppLaunch(false);

      final reloaded = LocalAppSettings();
      reloaded.resetForTest();
      await reloaded.init();

      expect(reloaded.getDeviceFound(), isTrue);
      expect(reloaded.getFirstAppLaunch(), isFalse);
    });

    test('init restores previously stored values', () async {
      SharedPreferences.setMockInitialValues({
        'deviceIp': '10.0.0.5',
        'typeRemoteSelected': LocalAppSettings.SIMPLE_REMOTE_CONTROLLER,
        'typeRemoteThemeSelected': LocalAppSettings.CLEAR_THEME,
        'deviceFound': true,
        'firstAppLaunch': false,
      });

      settings.resetForTest();
      await settings.init();

      expect(settings.getDeviceIp(), '10.0.0.5');
      expect(
        settings.getTypeRemoteSelected(),
        LocalAppSettings.SIMPLE_REMOTE_CONTROLLER,
      );
      expect(
        settings.getTypeRemoteThemeSelected(),
        LocalAppSettings.CLEAR_THEME,
      );
      expect(settings.getDeviceFound(), isTrue);
      expect(settings.getFirstAppLaunch(), isFalse);
    });
  });
}
