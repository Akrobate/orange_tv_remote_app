import 'package:flutter_test/flutter_test.dart';
import 'package:orange_tv_remote_app/constants/device_http_params.dart';

void main() {
  group('DeviceHttpParams', () {
    test('exposes expected remote key codes', () {
      expect(DeviceHttpParams.ON_OFF, 116);
      expect(DeviceHttpParams.OK, 352);
      expect(DeviceHttpParams.UP, 103);
      expect(DeviceHttpParams.DOWN, 108);
      expect(DeviceHttpParams.LEFT, 105);
      expect(DeviceHttpParams.RIGHT, 106);
      expect(DeviceHttpParams.VOLUME_UP, 115);
      expect(DeviceHttpParams.VOLUME_DOWN, 114);
      expect(DeviceHttpParams.CHANNEL_0, 512);
      expect(DeviceHttpParams.CHANNEL_9, 521);
    });

    test('exposes expected command modes', () {
      expect(DeviceHttpParams.MODE_SIMPLE, 0);
      expect(DeviceHttpParams.MODE_BUTTON_PRESS, 1);
      expect(DeviceHttpParams.MODE_BUTTON_RELEASE, 2);
    });
  });
}
