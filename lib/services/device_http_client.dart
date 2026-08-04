import 'package:http/http.dart' as http;
import 'package:orange_tv_remote_app/constants/device_http_params.dart';
import 'dart:convert';

class DeviceHttpClient {
  DeviceHttpClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  String deviceIp = '';
  final String devicePort = '8080';

  Future<void> commandModeSimple(int key) async {
    return this.command(DeviceHttpParams.MODE_SIMPLE, key);
  }

  Future<void> command(int mode, int command) async {
    if (deviceIp.isEmpty) return;

    final uri = Uri.http('$deviceIp:$devicePort', '/remoteControl/cmd', {
      'operation': '01',
      'key': command.toString(),
      'mode': mode.toString(),
    });

    try {
      await _httpClient.get(uri);
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
      final response = await _httpClient.get(uri);
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (error) {
      print('Error getting device info: $error');
    }
    return null;
  }

  Future<bool> checkDevice(
    String deviceIpString, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    if (deviceIpString.isEmpty) return false;

    final uri = Uri.http('$deviceIpString:$devicePort', '/remoteControl/cmd', {
      'operation': '10',
    });

    try {
      final response = await _httpClient.get(uri).timeout(timeout);
      if (response.statusCode == 200) {
        final Map<String, dynamic> result = jsonDecode(response.body);
        if (result['result'] != null && result['result']['message'] == 'ok') {
          return true;
        }
      }
    } catch (_) {
      // A closed port, timeout or non-box service just means "not the box".
    }

    return false;
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
