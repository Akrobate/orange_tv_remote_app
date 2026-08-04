import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:orange_tv_remote_app/services/device_discovery_service.dart';
import 'package:orange_tv_remote_app/services/device_http_client.dart';

void main() {
  group('DeviceDiscoveryService', () {
    test('returns notOnWifi when connectivity has no wifi', () async {
      final service = DeviceDiscoveryService(
        connectivityChecker: () async => [ConnectivityResult.mobile],
        wifiIpResolver: () async => '192.168.1.42',
        httpClient: DeviceHttpClient(
          httpClient: MockClient((_) async {
            return http.Response('{"result":{"message":"ok"}}', 200);
          }),
        ),
      );

      final result = await service.findDevice(firstHostId: 1, lastHostId: 3);

      expect(result.status, DiscoveryStatus.notOnWifi);
      expect(result.ip, isNull);
    });

    test('returns notOnWifi when wifi IP is unavailable', () async {
      final service = DeviceDiscoveryService(
        connectivityChecker: () async => [ConnectivityResult.wifi],
        wifiIpResolver: () async => null,
        httpClient: DeviceHttpClient(
          httpClient: MockClient((_) async {
            return http.Response('{"result":{"message":"ok"}}', 200);
          }),
        ),
      );

      final result = await service.findDevice(firstHostId: 1, lastHostId: 3);

      expect(result.status, DiscoveryStatus.notOnWifi);
    });

    test('returns found with the first matching box IP', () async {
      final probedIps = <String>[];
      final service = DeviceDiscoveryService(
        connectivityChecker: () async => [ConnectivityResult.wifi],
        wifiIpResolver: () async => '10.0.0.42',
        httpClient: DeviceHttpClient(
          httpClient: MockClient((request) async {
            probedIps.add(request.url.host);
            if (request.url.host == '10.0.0.2') {
              return http.Response('{"result":{"message":"ok"}}', 200);
            }
            return http.Response('{"result":{"message":"error"}}', 200);
          }),
        ),
      );

      final result = await service.findDevice(
        firstHostId: 1,
        lastHostId: 5,
        concurrency: 2,
        hostTimeout: const Duration(milliseconds: 100),
      );

      expect(result.status, DiscoveryStatus.found);
      expect(result.ip, '10.0.0.2');
      expect(probedIps, contains('10.0.0.2'));
      expect(probedIps, isNot(contains('10.0.0.5')));
    });

    test('returns notFound when no host matches the box signature', () async {
      final service = DeviceDiscoveryService(
        connectivityChecker: () async => [ConnectivityResult.wifi],
        wifiIpResolver: () async => '192.168.0.10',
        httpClient: DeviceHttpClient(
          httpClient: MockClient((_) async {
            return http.Response('{"result":{"message":"error"}}', 200);
          }),
        ),
      );

      final result = await service.findDevice(
        firstHostId: 1,
        lastHostId: 4,
        concurrency: 4,
        hostTimeout: const Duration(milliseconds: 50),
      );

      expect(result.status, DiscoveryStatus.notFound);
      expect(result.ip, isNull);
    });

    test('reports progress while scanning', () async {
      final progress = <int>[];
      final service = DeviceDiscoveryService(
        connectivityChecker: () async => [ConnectivityResult.wifi],
        wifiIpResolver: () async => '192.168.1.5',
        httpClient: DeviceHttpClient(
          httpClient: MockClient((_) async {
            return http.Response('{"result":{"message":"error"}}', 200);
          }),
        ),
      );

      await service.findDevice(
        firstHostId: 1,
        lastHostId: 3,
        concurrency: 1,
        hostTimeout: const Duration(milliseconds: 50),
        onProgress: (scanned, total) {
          progress.add(scanned);
          expect(total, 3);
        },
      );

      expect(progress, [1, 2, 3]);
    });

    test('derives subnet from wifi IP without forcing 192.168.1', () async {
      late String probedHost;
      final service = DeviceDiscoveryService(
        connectivityChecker: () async => [ConnectivityResult.wifi],
        wifiIpResolver: () async => '10.20.30.40',
        httpClient: DeviceHttpClient(
          httpClient: MockClient((request) async {
            probedHost = request.url.host;
            return http.Response('{"result":{"message":"ok"}}', 200);
          }),
        ),
      );

      final result = await service.findDevice(
        firstHostId: 7,
        lastHostId: 7,
        concurrency: 1,
      );

      expect(result.status, DiscoveryStatus.found);
      expect(result.ip, '10.20.30.7');
      expect(probedHost, '10.20.30.7');
    });
  });
}
