import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:orange_tv_remote_app/constants/device_http_params.dart';
import 'package:orange_tv_remote_app/services/device_http_client.dart';

void main() {
  group('DeviceHttpClient', () {
    test('stores and returns device IP and port', () {
      final client = DeviceHttpClient(httpClient: MockClient((_) async {
        return http.Response('', 200);
      }));

      client.setDeviceIp('192.168.1.10');

      expect(client.getDeviceIp(), '192.168.1.10');
      expect(client.getDevicePort(), '8080');
    });

    test('command does nothing when device IP is empty', () async {
      var called = false;
      final client = DeviceHttpClient(httpClient: MockClient((_) async {
        called = true;
        return http.Response('', 200);
      }));

      await client.command(DeviceHttpParams.MODE_SIMPLE, DeviceHttpParams.OK);

      expect(called, isFalse);
    });

    test('command sends the expected remote control URL', () async {
      late Uri capturedUri;
      final client = DeviceHttpClient(httpClient: MockClient((request) async {
        capturedUri = request.url;
        return http.Response('', 200);
      }));
      client.setDeviceIp('192.168.1.10');

      await client.commandModeSimple(DeviceHttpParams.OK);

      expect(capturedUri.scheme, 'http');
      expect(capturedUri.host, '192.168.1.10');
      expect(capturedUri.port, 8080);
      expect(capturedUri.path, '/remoteControl/cmd');
      expect(capturedUri.queryParameters['operation'], '01');
      expect(capturedUri.queryParameters['key'], '${DeviceHttpParams.OK}');
      expect(
        capturedUri.queryParameters['mode'],
        '${DeviceHttpParams.MODE_SIMPLE}',
      );
    });

    test('getInfo returns null when device IP is empty', () async {
      final client = DeviceHttpClient(httpClient: MockClient((_) async {
        return http.Response('{"result":{"message":"ok"}}', 200);
      }));

      expect(await client.getInfo(), isNull);
    });

    test('getInfo returns decoded JSON on success', () async {
      final client = DeviceHttpClient(httpClient: MockClient((_) async {
        return http.Response('{"result":{"message":"ok","data":1}}', 200);
      }));
      client.setDeviceIp('192.168.1.10');

      final info = await client.getInfo();

      expect(info, isNotNull);
      expect(info!['result']['message'], 'ok');
    });

    test('getInfo returns null on non-200 responses', () async {
      final client = DeviceHttpClient(httpClient: MockClient((_) async {
        return http.Response('error', 500);
      }));
      client.setDeviceIp('192.168.1.10');

      expect(await client.getInfo(), isNull);
    });

    test('checkDevice returns false for empty IP', () async {
      final client = DeviceHttpClient(httpClient: MockClient((_) async {
        return http.Response('{"result":{"message":"ok"}}', 200);
      }));

      expect(await client.checkDevice(''), isFalse);
    });

    test('checkDevice returns true for box signature', () async {
      final client = DeviceHttpClient(httpClient: MockClient((request) async {
        expect(request.url.queryParameters['operation'], '10');
        return http.Response('{"result":{"message":"ok"}}', 200);
      }));

      expect(await client.checkDevice('192.168.1.20'), isTrue);
    });

    test('checkDevice returns false when message is not ok', () async {
      final client = DeviceHttpClient(httpClient: MockClient((_) async {
        return http.Response('{"result":{"message":"error"}}', 200);
      }));

      expect(await client.checkDevice('192.168.1.20'), isFalse);
    });

    test('checkDevice returns false when the request fails', () async {
      final client = DeviceHttpClient(httpClient: MockClient((_) async {
        throw Exception('network down');
      }));

      expect(await client.checkDevice('192.168.1.20'), isFalse);
    });
  });
}
