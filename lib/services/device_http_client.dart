import 'package:http/http.dart' as http;
import 'package:orange_tv_remote_app/constants/device_http_params.dart';
import 'dart:convert';

class DeviceHttpClient {

  late String deviceIp;
  final String devicePort = '8080';


  Future<void> commandModeSimple(int command) async {
    return this.command(DeviceHttpParams.MODE_SIMPLE, command);
  }

  Future<void> command(int mode, int command) async {
    if (deviceIp.isEmpty) return;

    // Construction propre de l'URL avec Uri.http
    final uri = Uri.http('$deviceIp:$devicePort', '/remoteControl/cmd', {
      'operation': '01',
      'key': command.toString(),
      'mode': mode.toString(),
    });

    try {
      await http.get(uri);
    } catch (error) {
      print('Error sending command: $error');
    }
  }


  Future<Map<String, dynamic>?> getInfo() async {
    if (deviceIp.isEmpty) return null;

    final uri = Uri.http('$deviceIp:$devicePort', '/remoteControl/cmd', {
      'operation': '10',
    });

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (error) {
      print('Error getting device info: $error');
    }
    return null;
  }

  Future<bool> checkDevice(String deviceIpString) async {
    if (deviceIpString.isEmpty) return false;

    bool returnValue = false;

    final uri = Uri.http('$deviceIpString:$devicePort', '/remoteControl/cmd', {
      'operation': '10',
    });

    print(uri.toString());

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final Map<String, dynamic> result = jsonDecode(response.body);
        if (result['result'] != null && result['result']['message'] == 'ok') {
          returnValue = true;
        }
      }
    } catch (error) {
      print('Error checking device: $error');
    }

    return returnValue;
  }

  void setDeviceIp(String _deviceIp) {
    deviceIp = _deviceIp;
  }

  String getDeviceIp() {
    return deviceIp;
  }

  String getDevicePort() {
    return devicePort;
  }

}
