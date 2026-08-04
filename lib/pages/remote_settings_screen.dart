import 'package:flutter/material.dart';
import 'package:orange_tv_remote_app/services/local_app_settings.dart';
import 'package:orange_tv_remote_app/services/device_discovery_service.dart';
import 'package:orange_tv_remote_app/themes/theme_abstract.dart';
import 'package:orange_tv_remote_app/themes/themes_manager.dart';

class RemoteSettingsScreen extends StatefulWidget {
  @override
  _RemoteSettingsScreenState createState() => _RemoteSettingsScreenState();
}

class _RemoteSettingsScreenState extends State<RemoteSettingsScreen> {

  final LocalAppSettings appSettings = LocalAppSettings();
  bool useClearTheme = false;
  bool useSimpleRemoteController = false;

  final DeviceDiscoveryService discoveryService = DeviceDiscoveryService();
  bool isSearching = false;

  final ipFieldController = TextEditingController();

  @override
  initState(){
    super.initState();
    setState(() {

      ipFieldController.text = appSettings.getDeviceIp();

      int typeRemoteSelected = appSettings.getTypeRemoteSelected();
      if (typeRemoteSelected == LocalAppSettings.SIMPLE_REMOTE_CONTROLLER) {
        useSimpleRemoteController = true;
      } else {
        useSimpleRemoteController = false;
      }

      int typeRemoteThemeSelected = appSettings.getTypeRemoteThemeSelected();
      if (typeRemoteThemeSelected == LocalAppSettings.DARK_THEME) {
        useClearTheme = false;
      } else {
        useClearTheme = true;
      }
    });
  }

  @override
  void dispose() {
    ipFieldController.dispose();
    super.dispose();
  }

  void saveTypeRemote() {
    if (useSimpleRemoteController) {
      appSettings.setTypeRemoteSelected(LocalAppSettings.SIMPLE_REMOTE_CONTROLLER);
    } else {
      appSettings.setTypeRemoteSelected(LocalAppSettings.ADVANCED_REMOTE_CONTROLLER);
    }
  }


  void saveThemeRemote() {
    if (useClearTheme) {
      appSettings.setTypeRemoteThemeSelected(LocalAppSettings.CLEAR_THEME);
    } else {
      appSettings.setTypeRemoteThemeSelected(LocalAppSettings.DARK_THEME);
    }
  }

  void dialog(context, title, message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(title),
            content: new Text(message),
            actions: <Widget>[
              new TextButton(
                  child: new Text("Fermer"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        }
    );
  }

  Future<void> searchDeviceOnNetwork(BuildContext context) async {
    if (isSearching) return;

    setState(() {
      isSearching = true;
    });

    DiscoveryResult result;
    try {
      result = await discoveryService.findDevice();
    } finally {
      if (mounted) {
        setState(() {
          isSearching = false;
        });
      }
    }

    if (!mounted) return;

    switch (result.status) {
      case DiscoveryStatus.found:
        final String ip = result.ip!;
        appSettings.setDeviceIp(ip);
        setState(() {
          ipFieldController.text = ip;
        });
        dialog(
          context,
          'Box trouvée',
          'Votre box a été trouvée à l\'adresse $ip et enregistrée dans l\'application.',
        );
        break;
      case DiscoveryStatus.notOnWifi:
        dialog(
          context,
          'Wi-Fi requis',
          'Connectez votre téléphone au même réseau Wi-Fi que la box, puis réessayez.',
        );
        break;
      case DiscoveryStatus.notFound:
        dialog(
          context,
          'Box non trouvée',
          'Impossible de trouver votre box. Saisissez son adresse IP manuellement.',
        );
        break;
    }
  }

  Widget _buildSection(String title, Color textColor, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 12.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
        child,
      ],
    );
  }

  Widget _buildChoiceCard({
    required IconData icon,
    required String label,
    required bool selected,
    required Color textColor,
    required Color accent,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 22.0),
        decoration: BoxDecoration(
          color: selected ? accent.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(14.0),
          border: Border.all(
            color: selected ? accent : textColor.withValues(alpha: 0.25),
            width: selected ? 2.0 : 1.0,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 34.0,
              color: selected ? accent : textColor.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 10.0),
            Text(
              label,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? accent : textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final ThemeAbstract theme = ThemeManager.getTheme(
      useClearTheme ? ThemeAbstract.CLEAR_THEME : ThemeAbstract.DARK_THEME,
    );
    final Color backgroundColor = theme.getRemoteControllerBackgroundColor();
    final Color appBarBackgroundColor = theme.getAppBarBackgroundColor();
    final Color textColor = useClearTheme ? Colors.black87 : Colors.white;
    final Color accent = useClearTheme
        ? (Colors.deepOrange[800] ?? Colors.deepOrange)
        : Colors.green;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Paramètres'),
        centerTitle: true,
        backgroundColor: appBarBackgroundColor,
        foregroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Center(
        child:  SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSection(
                  'Type de télécommande',
                  textColor,
                  Row(
                    children: [
                      Expanded(
                        child: _buildChoiceCard(
                          icon: Icons.tv,
                          label: 'Simplifiée',
                          selected: useSimpleRemoteController,
                          textColor: textColor,
                          accent: accent,
                          onTap: () {
                            setState(() {
                              useSimpleRemoteController = true;
                              saveTypeRemote();
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 14.0),
                      Expanded(
                        child: _buildChoiceCard(
                          icon: Icons.settings_remote,
                          label: 'Avancée',
                          selected: !useSimpleRemoteController,
                          textColor: textColor,
                          accent: accent,
                          onTap: () {
                            setState(() {
                              useSimpleRemoteController = false;
                              saveTypeRemote();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32.0),
                _buildSection(
                  'Apparence',
                  textColor,
                  Row(
                    children: [
                      Expanded(
                        child: _buildChoiceCard(
                          icon: Icons.dark_mode,
                          label: 'Sombre',
                          selected: !useClearTheme,
                          textColor: textColor,
                          accent: accent,
                          onTap: () {
                            setState(() {
                              useClearTheme = false;
                              saveThemeRemote();
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 14.0),
                      Expanded(
                        child: _buildChoiceCard(
                          icon: Icons.light_mode,
                          label: 'Clair',
                          selected: useClearTheme,
                          textColor: textColor,
                          accent: accent,
                          onTap: () {
                            setState(() {
                              useClearTheme = true;
                              saveThemeRemote();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40.0),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: ipFieldController,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 24.0,
                    ),
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: 'Adresse ip',
                      hintStyle: TextStyle(
                        color: Colors.grey[800],
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[800]!),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: textColor),
                      ),
                    ),
                    onSubmitted: (deviceIp) {
                      appSettings.setDeviceIp(deviceIp);
                    }
                  ),
                ),
                SizedBox(height: 20),
                TextButton.icon(
                  onPressed: isSearching
                      ? null
                      : () {
                          searchDeviceOnNetwork(context);
                        },
                  style: TextButton.styleFrom(
                    backgroundColor: accent,
                    disabledBackgroundColor: accent.withValues(alpha: 0.6),
                    padding: EdgeInsets.all(10.0),
                  ),
                  label: Text(
                    isSearching ? 'Recherche en cours…' : 'Recherche automatique',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  icon: isSearching
                      ? SizedBox(
                          width: 18.0,
                          height: 18.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Icon(Icons.search, color: Colors.white),
                ),
              ]
            ),
          ),
        )
      )
    );
  }
}
