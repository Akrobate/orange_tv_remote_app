# Orange TV Remote

A Flutter app that turns your phone into a remote control for Orange Livebox / Orange TV set-top boxes on your local Wi‑Fi network.

Commands are sent over HTTP to the box’s built-in remote control API (`:8080`), so the phone and the box must be on the **same local network**.


## Features

### Remote control
- Full on-screen remote with the usual TV actions:
  - Power, navigation (↑ ↓ ← → OK), Back, Menu, VOD
  - Volume up / down / mute
  - Channel up / down and numeric keypad (0–9)
  - Play / pause, fast forward / rewind, record
- Two layouts:
  - **Advanced** — denser remote with the numeric keypad
  - **Simple** — larger touch targets, fewer buttons

### Appearance
- **Dark** and **Clear** themes
- Theme applies to both the remote screen and the settings screen
- Accent color adapts to the selected theme (green in dark mode, orange in clear mode)

### Settings
- Choose remote layout (Simple / Advanced) with card selectors
- Choose appearance (Dark / Clear)
- Set the box IP address manually
- **Automatic discovery** — scan the local Wi‑Fi subnet and detect the box via its remote API signature
- Settings are persisted locally with `shared_preferences`

### Platform polish
- Safe area support so the remote sits above Android system navigation buttons
- Portrait-only orientation
- Custom launcher icon (Android, iOS, web)


## How it works

1. The app stores the box IP (manual entry or auto-discovery).
2. Each button press sends an HTTP GET request to:

   ```
   http://<box-ip>:8080/remoteControl/cmd?operation=01&key=<code>&mode=0
   ```

3. Auto-discovery:
   - Confirms the phone is on Wi‑Fi
   - Derives the `/24` subnet from the phone’s Wi‑Fi IP
   - Probes hosts in parallel
   - Validates candidates with `operation=10` and checks that the JSON response contains `result.message == "ok"`

> **Note:** Cleartext HTTP is required because the box API does not use HTTPS. The Android app enables `usesCleartextTraffic` for this local use case.


## Project structure

```
lib/
├── main.dart                          # App entry, settings init
├── constants/
│   └── device_http_params.dart        # Key codes & command modes
├── pages/
│   ├── remote_controller_screen.dart  # Main remote UI
│   └── remote_settings_screen.dart    # Settings UI
├── remote_controller_widgets/
│   ├── advanced_remote_controller.dart
│   └── simple_remote_controller.dart
├── services/
│   ├── device_http_client.dart        # HTTP commands to the box
│   ├── device_discovery_service.dart  # Local network discovery
│   └── local_app_settings.dart        # Persisted preferences
└── themes/
    ├── theme_abstract.dart
    ├── dark_theme.dart
    ├── clear_theme.dart
    └── themes_manager.dart
```


## Requirements

- [Flutter](https://docs.flutter.dev/get-started/install) (stable channel recommended)
- Dart SDK compatible with `pubspec.yaml` (`>=2.12.0`)
- Android SDK (for Android builds)
- Phone and Orange TV box on the **same Wi‑Fi network**


## Getting started

```bash
# Clone / open the project, then:
flutter pub get

# Run on a connected device or emulator
flutter run

# Run the test suite
flutter test
```

### Install on a physical Android phone (USB)

1. Enable **Developer options** and **USB debugging** on the phone.
2. Connect via USB and verify:

   ```bash
   flutter devices
   ```

3. Install and launch:

   ```bash
   flutter run
   ```

   Or build an APK:

   ```bash
   flutter build apk --debug    # debug
   flutter build apk --release  # release
   ```

   APK output:

   ```
   build/app/outputs/flutter-apk/app-debug.apk
   build/app/outputs/flutter-apk/app-release.apk
   ```

### First use

1. Open **Settings** (gear icon).
2. Either:
   - Tap **Automatic search** while on the same Wi‑Fi as the box, or
   - Enter the box IP manually and confirm with the keyboard Done action.
3. Pick **Simple** or **Advanced** remote, and **Dark** or **Clear** theme.
4. Go back — the remote screen updates immediately.


## Tests

The project includes unit and widget tests covering:

- Local settings persistence
- HTTP client command URLs and box signature checks
- Device discovery (Wi‑Fi required, found / not found, progress, subnet derivation)
- Theme selection
- Remote and settings screens (layout switch, theme switch, IP save)

```bash
flutter test
```


## Launcher icon

Icons are generated with [`flutter_launcher_icons`](https://pub.dev/packages/flutter_launcher_icons) from:

```
assets/icon/app_icon.png
```

To regenerate after changing the source image:

```bash
dart run flutter_launcher_icons
```


## Dependencies

| Package | Role |
|---|---|
| `http` | Talk to the box remote API |
| `shared_preferences` | Persist IP, theme, remote layout |
| `network_info_plus` | Read Wi‑Fi IP for discovery |
| `connectivity_plus` | Ensure discovery only runs on Wi‑Fi |


## Limitations

- Works only on the **local network** (no remote / internet control).
- Discovery scans the phone’s `/24` subnet; if the box is on another subnet/VLAN, enter the IP manually.
- The box must expose the classic Orange remote HTTP API on port **8080**.
- Release APKs currently use the default debug signing unless you configure your own keystore.


## License

See [LICENSE](LICENSE).
