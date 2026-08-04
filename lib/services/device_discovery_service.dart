import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:orange_tv_remote_app/services/device_http_client.dart';

/// Outcome of an automatic discovery run.
enum DiscoveryStatus { found, notFound, notOnWifi }

class DiscoveryResult {
  final DiscoveryStatus status;
  final String? ip;

  const DiscoveryResult(this.status, {this.ip});
}

typedef ConnectivityChecker = Future<List<ConnectivityResult>> Function();
typedef WifiIpResolver = Future<String?> Function();

/// Discovers the Orange TV box on the local network.
///
/// Principle (unchanged from the original implementation):
///   1. Determine the phone's own Wi-Fi IP and derive its /24 subnet.
///   2. Probe every host of that subnet and validate each candidate against
///      the box's remote-control API (via [DeviceHttpClient.checkDevice]).
///   3. Return the first host that answers with the box signature.
class DeviceDiscoveryService {
  DeviceDiscoveryService({
    DeviceHttpClient? httpClient,
    ConnectivityChecker? connectivityChecker,
    WifiIpResolver? wifiIpResolver,
  })  : _httpClient = httpClient ?? DeviceHttpClient(),
        _connectivityChecker = connectivityChecker ??
            (() => Connectivity().checkConnectivity()),
        _wifiIpResolver = wifiIpResolver ?? (() => NetworkInfo().getWifiIP());

  final DeviceHttpClient _httpClient;
  final ConnectivityChecker _connectivityChecker;
  final WifiIpResolver _wifiIpResolver;

  static const int defaultFirstHostId = 1;
  static const int defaultLastHostId = 254;

  Future<DiscoveryResult> findDevice({
    int concurrency = 32,
    Duration hostTimeout = const Duration(seconds: 1),
    int firstHostId = defaultFirstHostId,
    int lastHostId = defaultLastHostId,
    void Function(int scanned, int total)? onProgress,
  }) async {
    final subnet = await _resolveSubnet();
    if (subnet == null) {
      return const DiscoveryResult(DiscoveryStatus.notOnWifi);
    }

    final candidates = <String>[
      for (int hostId = firstHostId; hostId <= lastHostId; hostId++)
        '$subnet.$hostId',
    ];

    final iterator = candidates.iterator;
    final total = candidates.length;
    int scanned = 0;
    String? foundIp;

    Future<void> worker() async {
      // Dart runs on a single-threaded event loop, so `moveNext()` executes
      // synchronously between `await`s: sharing one iterator across the
      // workers hands out each address exactly once, without a data race.
      while (foundIp == null && iterator.moveNext()) {
        final ip = iterator.current;
        final isBox = await _httpClient.checkDevice(ip, timeout: hostTimeout);
        scanned++;
        onProgress?.call(scanned, total);
        if (isBox) {
          foundIp = ip;
          return;
        }
      }
    }

    final workerCount = concurrency < total ? concurrency : total;
    await Future.wait([for (int i = 0; i < workerCount; i++) worker()]);

    if (foundIp != null) {
      return DiscoveryResult(DiscoveryStatus.found, ip: foundIp);
    }
    return const DiscoveryResult(DiscoveryStatus.notFound);
  }

  Future<String?> _resolveSubnet() async {
    final connectivity = await _connectivityChecker();
    if (!connectivity.contains(ConnectivityResult.wifi)) {
      return null;
    }

    final wifiIp = await _wifiIpResolver();
    if (wifiIp == null || !wifiIp.contains('.')) {
      return null;
    }

    return wifiIp.substring(0, wifiIp.lastIndexOf('.'));
  }
}
