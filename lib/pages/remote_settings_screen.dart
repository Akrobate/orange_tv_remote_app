import 'package:flutter/material.dart';
import 'package:orange_tv_remote_app/services/local_app_settings.dart';
import 'package:orange_tv_remote_app/services/device_http_client.dart';
// import 'package:ping_discover_network/ping_discover_network.dart';
// import 'package:wifi/wifi.dart';

class RemoteSettingsScreen extends StatefulWidget {
  @override
  _RemoteSettingsScreenState createState() => _RemoteSettingsScreenState();
}

class _RemoteSettingsScreenState extends State<RemoteSettingsScreen> {

  final LocalAppSettings appSettings = LocalAppSettings();
  bool useClearTheme = false;
  bool useSimpleRemoteController = false;

  final DeviceHttpClient device = DeviceHttpClient();

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

  void searchDeviceOnNetwork(context) async {

    /*

    final String ip = await Wifi.ip;
    String subnet = ip.substring(0, ip.lastIndexOf('.'));
    String subnetFirst = ip.substring(0, subnet.lastIndexOf('.'));
    List<String> foundDevices = [];

    subnet = subnetFirst != '192.168' ? '192.168.1' : subnet;

    String port = device.getDevicePort();
    final stream = NetworkAnalyzer.discover2(
      subnet,
      int.parse(port),
      timeout: Duration(milliseconds: 5000),
    );

    stream.listen((NetworkAddress address) {
      if (address.exists) {
        print('Found device: ${address.ip}:$port');
        foundDevices.add(address.ip);
      }
    }).onDone(() async {
      print(foundDevices);

      if (foundDevices.length > 0) {
        List<Future> futures = <Future>[];
        for (String ip_to_test in foundDevices) {
          futures.add(device.checkDevice(ip_to_test));
        }
        var pingDeviceResultList = await Future.wait(futures);
        int indexFoundDevice = pingDeviceResultList.indexOf(true);
        appSettings.setDeviceIp(foundDevices[indexFoundDevice]);
        setState(() {
          ipFieldController.text = appSettings.getDeviceIp();
        });
        dialog(
          context,
          'Box trouvée',
          'Votre box a bien été trouvée et son ip enregitrée dans l\'application'
        );
      } else {
        dialog(
          context,
          'Box non trouvée',
          'Impossible de trouver votre box, saisissez son ip manuellement.'
        );
      }
    });

    */
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Paramètres'),
        centerTitle: true,
        backgroundColor: Colors.grey[850],
        elevation: 0.0,
      ),
      body: Center(
        child:  SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Utiliser la télécommande simplifiée',
                  style: TextStyle(
                    fontSize: 22.0,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                Transform.scale(
                  scale: 2.0,
                  child: Switch(
                    onChanged: (value) {
                      setState(() {
                        useSimpleRemoteController = value;
                        saveTypeRemote();
                      });
                    },
                    value: useSimpleRemoteController,
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                    inactiveTrackColor: Colors.green[900],
                  ),
                ),
                SizedBox(height: 40.0),
                Text(
                  'Télécommande sur fond clair',
                  style: TextStyle(
                    fontSize: 22.0,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                Transform.scale(
                  scale: 2.0,
                  child: Switch(
                    onChanged: (value) {
                      setState(() {
                        useClearTheme = value;
                        saveThemeRemote();
                      });
                    },
                    value: useClearTheme,
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                    inactiveTrackColor: Colors.green[900],
                  ),
                ),
                SizedBox(height: 40.0),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: ipFieldController,
                    style: TextStyle(
                      color: Colors.white,
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
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    onSubmitted: (deviceIp) {
                      appSettings.setDeviceIp(deviceIp);
                    }
                  ),
                ),
                SizedBox(height: 20),
                TextButton.icon(
                  onPressed: () {
                    searchDeviceOnNetwork(context);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.all(10.0),
                  ),
                  label: Text(
                    'Recherche automatique',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  icon: Icon(Icons.search),
                ),
              ]
            ),
          ),
        )
      )
    );
  }
}
