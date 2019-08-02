import 'package:flutter/material.dart';

import '../service/service_provider.dart';
import '../style/app_style.dart';

class InstanceStyleService {
  AppStyle _appStyle = AppStyle();

  AppStyle _defaultAppStyle = AppStyle(
    themeColor: MaterialColor(0xFF25814E, <int, Color>{
      50: const Color(0xFF25814E),
      100: const Color(0xFF25814E),
      200: const Color(0xFF25814E),
      300: const Color(0xFF25814E),
      400: const Color(0xFF25814E),
      500: const Color(0xFF25814E),
      600: const Color(0xFF25814E),
      700: const Color(0xFF25814E),
      800: const Color(0xFF25814E),
      900: const Color(0xFF25814E),
    }),
    backgroundColor: Color.fromARGB(255, 240, 240, 240),
  );

  InstanceStyleService() {
    print('InstanceStyleService: constructor');
  }

  /// The global style for this application.
  /// The style can be instance specific such
  /// as the theme color may be the color of the
  /// company who uses the instance
  AppStyle get appStyle => (_appStyle ?? _defaultAppStyle);

  bool _standardStyleSet = false;

  void setStandardStyle(double screenHeight, double factor) {
    print('InstanceStyleService: setStandardStyle');

    _appStyle.backgroundColor = new Color.fromARGB(255, 240, 240, 240);

    _appStyle.lightYellow = new Color.fromARGB(255, 248, 255, 229);
    _appStyle.caribbeanGreen = new Color.fromARGB(255, 6, 214, 160);
    _appStyle.lightSeaGreen = new Color.fromARGB(255, 27, 154, 170);
    _appStyle.infraRed = new Color.fromARGB(255, 239, 71, 111);
    _appStyle.sunGlow = new Color.fromARGB(255, 255, 196, 61);
    _appStyle.textGrey = new Color.fromARGB(255, 92, 107, 115);
    _appStyle.card = new Color.fromARGB(255, 255, 222, 166);

    _appStyle.title = new TextStyle(
      fontSize: screenHeight * 0.040 * factor,
      fontFamily: 'Asap',
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.normal,
      color: _appStyle.lightYellow,
    );

    _appStyle.secondaryTitle = new TextStyle(
      fontSize: screenHeight * 0.030 * factor,
      fontFamily: 'Asap',
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.normal,
      color: _appStyle.textGrey,
    );

    _appStyle.thirdTitle = new TextStyle(
      fontSize: screenHeight * 0.030 * factor,
      fontFamily: 'Asap',
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.normal,
      color: _appStyle.textGrey,
    );

    _appStyle.titleGrey = new TextStyle(
        fontSize: screenHeight * 0.040 * factor,
        fontFamily: 'Asap',
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.normal,
        color: _appStyle.textGrey);

    _appStyle.body1 = new TextStyle(
      fontFamily: "Asap",
      fontSize: screenHeight * 0.020 * factor,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      color: _appStyle.textGrey,
    );

    _appStyle.confirm = new TextStyle(
      fontFamily: "Asap",
      fontSize: screenHeight * 0.020 * factor,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      color: _appStyle.caribbeanGreen,
    );

    _appStyle.cancel = new TextStyle(
      fontFamily: "Asap",
      fontSize: screenHeight * 0.020 * factor,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      color: _appStyle.infraRed,
    );

    _appStyle.body1Black = new TextStyle(
      fontFamily: "Asap",
      fontSize: screenHeight * 0.020 * factor,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      color: Colors.black,
    );

    _appStyle.body1Bold = new TextStyle(
      fontSize: screenHeight * 0.020 * factor,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.normal,
      color: _appStyle.textGrey,
    );

    _appStyle.italic = new TextStyle(
      fontSize: screenHeight * 0.018 * factor,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.italic,
      color: _appStyle.textGrey,
    );

    _appStyle.body1Light = new TextStyle(
        fontSize: screenHeight * 0.020 * factor,
        fontFamily: "Asap",
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.normal,
        color: Colors.white);

    _appStyle.body2 = new TextStyle(
      fontSize: screenHeight * 0.024 * factor,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.italic,
      color: _appStyle.textGrey,
    );

    _appStyle.numberHead1 = new TextStyle(
      fontSize: screenHeight * 0.018 * factor,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      color: _appStyle.textGrey,
    );

    _appStyle.numberHead2 = new TextStyle(
      fontSize: screenHeight * 0.018 * factor,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.italic,
      color: _appStyle.textGrey,
    );

    _appStyle.textFieldLabel = new TextStyle(
      fontSize: screenHeight * 0.025 * factor,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.italic,
      color: _appStyle.lightYellow,
    );

    _appStyle.label = new TextStyle(
      fontSize: screenHeight * 0.025 * factor,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.italic,
      color: _appStyle.lightYellow,
    );

    _appStyle.labelLight = new TextStyle(
      fontSize: screenHeight * 0.025 * factor,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.italic,
      color: _appStyle.lightYellow,
    );

    _appStyle.buttonText = new TextStyle(
      fontFamily: "Asap",
      fontSize: screenHeight * 0.025 * factor,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.italic,
      color: _appStyle.lightYellow,
    );

    _appStyle.iconSizeStandard = screenHeight * 0.041 * factor;

    _appStyle.iconSizeBig = screenHeight * 0.051 * factor;

    _appStyle.activeIconColor = _appStyle.sunGlow;

    _appStyle.inactiveIconColor = _appStyle.textGrey;

    _defaultAppStyle = _appStyle;

    _standardStyleSet = true;
  }
}
