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

    _appStyle.backgroundColor = new Color.fromARGB(255, 255, 255, 255);

    _appStyle.mimiPink = new Color.fromARGB(255, 242, 215, 238);
    _appStyle.paleSilver = new Color.fromARGB(255, 211, 188, 192);
    _appStyle.mountbattenPink = new Color.fromARGB(255, 165, 102, 139);
    _appStyle.imperial = new Color.fromARGB(255, 105, 48, 109);
    _appStyle.maastrichtBlue = new Color.fromARGB(255, 14, 16, 61);
    _appStyle.leBleu = new Color.fromARGB(255, 122, 149, 241);
    _appStyle.textGrey = new Color.fromARGB(255, 92, 107, 115);
    _appStyle.card = new Color.fromARGB(255, 255, 222, 166);
    _appStyle.titleOneColor = Colors.black;

    _appStyle.title = new TextStyle(
      fontSize: screenHeight * 0.040 * factor,
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.normal,
      color: Colors.white,
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
        fontFamily: 'Montserrat',
        // fontWeight: FontWeight.bold,
        fontStyle: FontStyle.normal,
        color: _appStyle.textGrey);

    _appStyle.body1 = new TextStyle(
      fontFamily: "Montserrat",
      fontSize: screenHeight * 0.020 * factor,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      color: Colors.white,
    );

    _appStyle.confirm = new TextStyle(
      fontFamily: "Asap",
      fontSize: screenHeight * 0.020 * factor,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      color: _appStyle.mountbattenPink,
    );

    _appStyle.cancel = new TextStyle(
      fontFamily: "Asap",
      fontSize: screenHeight * 0.020 * factor,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      color: _appStyle.imperial,
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
      color: _appStyle.mimiPink,
    );

    _appStyle.label = new TextStyle(
      fontSize: screenHeight * 0.025 * factor,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.italic,
      color: _appStyle.mimiPink,
    );

    _appStyle.labelLight = new TextStyle(
      fontSize: screenHeight * 0.025 * factor,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.italic,
      color: _appStyle.mimiPink,
    );

    _appStyle.iconFloatText = new TextStyle(
      fontSize: screenHeight * 0.025 * factor,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.bold,
      color: _appStyle.imperial,
    );

    _appStyle.buttonText = new TextStyle(
      fontFamily: "Montserrat",
      fontSize: screenHeight * 0.023 * factor,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.normal,
      color: appStyle.maastrichtBlue,
    );

    _appStyle.iconSizeSmall = screenHeight * 0.031 * factor;

    _appStyle.iconSizeStandard = screenHeight * 0.041 * factor;

    _appStyle.iconSizeBig = screenHeight * 0.051 * factor;

    _appStyle.activeIconColor = _appStyle.mountbattenPink;

    _appStyle.inactiveIconColor = _appStyle.paleSilver;

    _defaultAppStyle = _appStyle;

    _standardStyleSet = true;
  }
}
