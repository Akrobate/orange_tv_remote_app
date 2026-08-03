import 'package:flutter/material.dart';
import 'package:orange_tv_remote_app/services/device_http_client.dart';
import 'package:orange_tv_remote_app/constants/device_http_params.dart';
import 'package:orange_tv_remote_app/services/local_app_settings.dart';
import 'package:orange_tv_remote_app/themes/theme_abstract.dart';

class SimpleRemoteController extends StatelessWidget {

  final LocalAppSettings appSettings = LocalAppSettings();
  final double buttonsIconSize = 64.0;
  final double buttonsEdgeInsetsAll = 8.0;
  final DeviceHttpClient device;
  final ThemeAbstract theme;

  SimpleRemoteController({
    required this.device,
    required this.theme,
  });

  controllerButtonPressed(int command) {
    device.commandModeSimple(command);
  }

  @override
  Widget build(BuildContext context) {

    Color buttonsColor = theme.getButtonsColor();

    return Column(
      children: <Widget>[

        // 1 line of buttons
        Expanded(
          child: Row(
            children: <Widget>[
              Expanded(
                child: ConstrainedBox(
                  constraints: BoxConstraints.expand(),
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: IconButton(
                      onPressed: () {
                        controllerButtonPressed(DeviceHttpParams.BACK);
                      },
                      padding: EdgeInsets.all(buttonsEdgeInsetsAll),
                      iconSize: buttonsIconSize,
                      icon: FittedBox(
                        fit: BoxFit.fill,
                        child: Icon(Icons.arrow_back),
                      ),
                      color: buttonsColor,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ConstrainedBox(
                  constraints: BoxConstraints.expand(),
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: IconButton(
                      onPressed: () {
                        controllerButtonPressed(DeviceHttpParams.UP);
                      },
                      padding: EdgeInsets.all(buttonsEdgeInsetsAll),
                      iconSize: buttonsIconSize,
                      icon: FittedBox(
                        fit: BoxFit.fill,
                        child: Icon(Icons.keyboard_arrow_up),
                      ),
                      color: buttonsColor,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ConstrainedBox(
                  constraints: BoxConstraints.expand(),
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: IconButton(
                      onPressed: () {
                        controllerButtonPressed(DeviceHttpParams.RECORD);
                      },
                      padding: EdgeInsets.all(buttonsEdgeInsetsAll),
                      iconSize: buttonsIconSize,
                      icon: FittedBox(
                        fit: BoxFit.fill,
                        child: Icon(Icons.radio_button_checked),
                      ),
                      color: buttonsColor,
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),


        // 2 line of buttons
        Expanded(
          child: Row(
            children: <Widget>[
              Expanded(
                child: ConstrainedBox(
                  constraints: BoxConstraints.expand(),
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: IconButton(
                      onPressed: () {
                        controllerButtonPressed(DeviceHttpParams.LEFT);
                      },
                      padding: EdgeInsets.all(buttonsEdgeInsetsAll),
                      iconSize: buttonsIconSize,
                      icon: FittedBox(
                        fit: BoxFit.fill,
                        child: Icon(Icons.chevron_left),
                      ),
                      color: buttonsColor,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ConstrainedBox(
                  constraints: BoxConstraints.expand(),
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: TextButton(
                      onPressed: () {
                        controllerButtonPressed(DeviceHttpParams.OK);
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                      ),
                      child: Text(
                          'Ok',
                          style: TextStyle(
                            fontSize: buttonsIconSize / 1.2,
                            color: buttonsColor,
                            fontWeight: FontWeight.bold,
                          )
                      ),
                      // color: buttonsColor,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ConstrainedBox(
                  constraints: BoxConstraints.expand(),
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: IconButton(
                      onPressed: () {
                        controllerButtonPressed(DeviceHttpParams.RIGHT);
                      },
                      padding: EdgeInsets.all(buttonsEdgeInsetsAll),
                      iconSize: buttonsIconSize,
                      icon: FittedBox(
                        fit: BoxFit.fill,
                        child: Icon(Icons.chevron_right),
                      ),
                      color: buttonsColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),


        // 3 line of buttons
        Expanded(
          child: Row(
            children: <Widget>[
              Expanded(
                child: ConstrainedBox(
                  constraints: BoxConstraints.expand(),
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: TextButton(
                      onPressed: () {
                        controllerButtonPressed(DeviceHttpParams.MENU);
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                      ),
                      child: Text(
                          'menu',
                          style: TextStyle(
                            fontSize: buttonsIconSize / 2.5,
                            color: buttonsColor,
                            fontWeight: FontWeight.bold,
                          )
                      ),
                      // color: buttonsColor,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ConstrainedBox(
                  constraints: BoxConstraints.expand(),
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: IconButton(
                      onPressed: () {
                        controllerButtonPressed(DeviceHttpParams.DOWN);
                      },
                      padding: EdgeInsets.all(buttonsEdgeInsetsAll),
                      iconSize: buttonsIconSize,
                      icon: FittedBox(
                        fit: BoxFit.fill,
                        child: Icon(Icons.keyboard_arrow_down),
                      ),
                      color: buttonsColor,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ConstrainedBox(
                  constraints: BoxConstraints.expand(),
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: TextButton(
                      onPressed: () {
                        controllerButtonPressed(DeviceHttpParams.VOD);
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                      ),
                      child: Text(
                          'VOD',
                          style: TextStyle(
                            fontSize: buttonsIconSize / 3,
                            color: buttonsColor,
                            fontWeight: FontWeight.bold,
                          )
                      ),
                      // color: buttonsColor,
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),


        // 4 line of buttons
        Expanded(
          child: Row(
            children: <Widget>[
              Expanded(
                child: ConstrainedBox(
                  constraints: BoxConstraints.expand(),
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: IconButton(
                      onPressed: () {
                        controllerButtonPressed(DeviceHttpParams.VOLUME_UP);
                      },
                      padding: EdgeInsets.all(buttonsEdgeInsetsAll),
                      iconSize: buttonsIconSize,
                      icon: FittedBox(
                        fit: BoxFit.fill,
                        child: Icon(Icons.volume_up),
                      ),
                      color: buttonsColor,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ConstrainedBox(
                  constraints: BoxConstraints.expand(),
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: IconButton(
                      onPressed: () {
                        controllerButtonPressed(DeviceHttpParams.FAST_FORWARD);
                      },
                      padding: EdgeInsets.all(buttonsEdgeInsetsAll),
                      iconSize: buttonsIconSize,
                      icon: FittedBox(
                        fit: BoxFit.fill,
                        child: Icon(Icons.fast_forward),
                      ),
                      color: buttonsColor,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ConstrainedBox(
                  constraints: BoxConstraints.expand(),
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: IconButton(
                      onPressed: () {
                        controllerButtonPressed(DeviceHttpParams.CHANNEL_NEXT);
                      },
                      padding: EdgeInsets.all(buttonsEdgeInsetsAll),
                      iconSize: buttonsIconSize,
                      icon: FittedBox(
                        fit: BoxFit.fill,
                        child: Icon(Icons.add_to_queue),
                      ),
                      color: buttonsColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),


        // 5 line of buttons
        Expanded(
          child: Row(
            children: <Widget>[
              Expanded(
                child: ConstrainedBox(
                  constraints: BoxConstraints.expand(),
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: IconButton(
                      onPressed: () {
                        controllerButtonPressed(DeviceHttpParams.VOLUME_DOWN);
                      },
                      padding: EdgeInsets.all(buttonsEdgeInsetsAll),
                      iconSize: buttonsIconSize,
                      icon: FittedBox(
                        fit: BoxFit.fill,
                        child: Icon(Icons.volume_down),
                      ),
                      color: buttonsColor,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ConstrainedBox(
                  constraints: BoxConstraints.expand(),
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: IconButton(
                      onPressed: () {
                        controllerButtonPressed(DeviceHttpParams.PLAY_PAUSE);
                      },
                      padding: EdgeInsets.all(buttonsEdgeInsetsAll),
                      iconSize: buttonsIconSize,
                      icon: FittedBox(
                        fit: BoxFit.fill,
                        child: Icon(Icons.play_arrow),
                      ),
                      color: buttonsColor,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ConstrainedBox(
                  constraints: BoxConstraints.expand(),
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: IconButton(
                      onPressed: () {
                        controllerButtonPressed(DeviceHttpParams.CHANNEL_PREVIOUS);
                      },
                      padding: EdgeInsets.all(buttonsEdgeInsetsAll),
                      iconSize: buttonsIconSize,
                      icon: FittedBox(
                        fit: BoxFit.fill,
                        child: Icon(Icons.remove_from_queue),
                      ),
                      color: buttonsColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),


        // 6 line of buttons
        Expanded(
          child: Row(
            children: <Widget>[
              Expanded(
                child: ConstrainedBox(
                  constraints: BoxConstraints.expand(),
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: IconButton(
                      onPressed: () {
                        controllerButtonPressed(DeviceHttpParams.VOLUME_MUTE);
                      },
                      padding: EdgeInsets.all(buttonsEdgeInsetsAll),
                      iconSize: buttonsIconSize,
                      icon: FittedBox(
                        fit: BoxFit.fill,
                        child: Icon(Icons.volume_off),
                      ),
                      color: buttonsColor,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ConstrainedBox(
                  constraints: BoxConstraints.expand(),
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: IconButton(
                      onPressed: () {
                        controllerButtonPressed(DeviceHttpParams.FAST_BACKWARD);
                      },
                      padding: EdgeInsets.all(buttonsEdgeInsetsAll),
                      iconSize: buttonsIconSize,
                      icon: FittedBox(
                        fit: BoxFit.fill,
                        child: Icon(Icons.fast_rewind),
                      ),
                      color: buttonsColor,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ConstrainedBox(
                  constraints: BoxConstraints.expand(),
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: IconButton(
                      onPressed: () {
                        controllerButtonPressed(DeviceHttpParams.ON_OFF);
                      },
                      padding: EdgeInsets.all(buttonsEdgeInsetsAll),
                      iconSize: buttonsIconSize,
                      icon: FittedBox(
                        fit: BoxFit.fill,
                        child: Icon(Icons.power_settings_new),
                      ),
                      color: buttonsColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

      ],
    );
  }
}
