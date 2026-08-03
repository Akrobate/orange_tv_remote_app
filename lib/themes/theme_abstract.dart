import 'package:flutter/material.dart';


abstract class ThemeAbstract {

  static const int DARK_THEME = 1;
  static const int CLEAR_THEME = 2;

  late Color buttonsColor;
  late Color remoteControllerBackgroundColor;
  late Color toolBarBackgroundColor;

  late int themeId;

  Color getButtonsColor() {
    return this.buttonsColor;
  }

  Color getRemoteControllerBackgroundColor() {
    return this.remoteControllerBackgroundColor;
  }

  Color getAppBarBackgroundColor() {
    return this.toolBarBackgroundColor;
  }
}