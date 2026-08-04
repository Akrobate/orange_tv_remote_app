import 'package:flutter_test/flutter_test.dart';
import 'package:orange_tv_remote_app/themes/clear_theme.dart';
import 'package:orange_tv_remote_app/themes/dark_theme.dart';
import 'package:orange_tv_remote_app/themes/theme_abstract.dart';
import 'package:orange_tv_remote_app/themes/themes_manager.dart';

void main() {
  group('ThemeManager', () {
    test('returns DarkTheme for DARK_THEME', () {
      final theme = ThemeManager.getTheme(ThemeAbstract.DARK_THEME);

      expect(theme, isA<DarkTheme>());
      expect(theme.themeId, ThemeAbstract.DARK_THEME);
    });

    test('returns ClearTheme for CLEAR_THEME', () {
      final theme = ThemeManager.getTheme(ThemeAbstract.CLEAR_THEME);

      expect(theme, isA<ClearTheme>());
      expect(theme.themeId, ThemeAbstract.CLEAR_THEME);
    });

    test('falls back to DarkTheme for unknown ids', () {
      final theme = ThemeManager.getTheme(999);

      expect(theme, isA<DarkTheme>());
    });

    test('dark and clear themes expose different colors', () {
      final dark = ThemeManager.getTheme(ThemeAbstract.DARK_THEME);
      final clear = ThemeManager.getTheme(ThemeAbstract.CLEAR_THEME);

      expect(
        dark.getRemoteControllerBackgroundColor(),
        isNot(clear.getRemoteControllerBackgroundColor()),
      );
      expect(dark.getButtonsColor(), isNot(clear.getButtonsColor()));
    });
  });
}
