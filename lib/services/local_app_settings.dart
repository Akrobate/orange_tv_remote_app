import 'package:shared_preferences/shared_preferences.dart';

class LocalAppSettings {

  static final LocalAppSettings _instance = LocalAppSettings._internal();

  dynamic preferencesInstance;

  static const int SIMPLE_REMOTE_CONTROLLER = 1;
  static const int ADVANCED_REMOTE_CONTROLLER = 2;
  static const int DEFAULT_REMOTE_CONTROLLER = LocalAppSettings.ADVANCED_REMOTE_CONTROLLER;

  static const int DARK_THEME = 1;
  static const int CLEAR_THEME = 2;
  static const int DEFAULT_THEME = LocalAppSettings.DARK_THEME;

  late String deviceIp;
  late int typeRemoteSelected;
  late int typeRemoteThemeSelected;
  late bool deviceFound;
  late bool firstAppLaunch;

  factory LocalAppSettings() {
    return _instance;
  }

  LocalAppSettings._internal();

  Future<void> init() async {
    preferencesInstance = await SharedPreferences.getInstance();
    deviceIp = preferencesInstance.getString('deviceIp') ?? '';
    typeRemoteSelected = preferencesInstance.getInt('typeRemoteSelected') ?? LocalAppSettings.DEFAULT_REMOTE_CONTROLLER;
    typeRemoteThemeSelected = preferencesInstance.getInt('typeRemoteThemeSelected') ?? LocalAppSettings.DEFAULT_THEME;
    deviceFound = preferencesInstance.getBool('deviceFound') ?? false;
    firstAppLaunch = preferencesInstance.getBool('firstAppLaunch') ?? true;
  }

  String getDeviceIp() {
    return deviceIp;
  }

  int getTypeRemoteSelected() {
    return typeRemoteSelected;
  }

  int getTypeRemoteThemeSelected() {
    return typeRemoteThemeSelected;
  }

  bool getDeviceFound() {
    return deviceFound;
  }

  bool getFirstAppLaunch() {
    return firstAppLaunch;
  }

  void setDeviceIp(String _deviceIp) {
    preferencesInstance.setString('deviceIp', _deviceIp);
    deviceIp = _deviceIp;
  }

  void setTypeRemoteSelected(int _typeRemoteSelected) {
    preferencesInstance.setInt('typeRemoteSelected', _typeRemoteSelected);
    typeRemoteSelected = _typeRemoteSelected;
  }

  void setTypeRemoteThemeSelected(int _typeRemoteThemeSelected) {
    preferencesInstance.setInt('typeRemoteThemeSelected', _typeRemoteThemeSelected);
    typeRemoteThemeSelected = _typeRemoteThemeSelected;
  }

  void setDeviceFound(bool _deviceFound) {
    preferencesInstance.setBool('deviceFound', _deviceFound);
    deviceFound = _deviceFound;
  }

  void setFirstAppLaunch(bool _firstAppLaunch) {
    preferencesInstance.setBool('firstAppLaunch', _firstAppLaunch);
    firstAppLaunch = _firstAppLaunch;
  }

}
