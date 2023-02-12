import 'package:flutter/material.dart';
import 'package:get/get.dart';

const urlLocalHost = "http://localhost:5000/";

abstract class OneColors {
  // !Cores usadas no app
  static const Color primaryDark = Color(0xFFD90D7D);
  static const Color primaryLight = Color(0xFFF0BCD9);
  static const Color accentDark = Color(0xFF1C2340);
  static const Color accentMidle = Color(0xFFB4C2CD);
  static const Color primaryBlue = Color(0xFF071D55);

  static const Color pink = Color(0xFFF52D6A);
  static const Color greenLight = Color(0xFF16EBD5);
  static const Color backShadow = Color(0x08208BFE);

  static const Color charcoalGray = Color(0xFF3C4142);
  static const Color charcoal = Color(0xFF343837);
  static const Color charcoalDarkBlue = Color(0xFF1B2431);
  static const Color darkBlue = Color(0xFF1F3B4D);
  static const Color white = Color(0xffF2F2F2);
  static const Color whiteBg = Color(0xFFFFFFFF);
  static const Color darkOrange = Color(0xffFC742B);
}

class Palette {
  static const MaterialColor primarySwatch = MaterialColor(
    0xFFD90D7D, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color.fromRGBO(217, 13, 125, 0.1), //10%
      100: Color.fromRGBO(217, 13, 125, 0.2), //20%
      200: Color.fromRGBO(217, 13, 125, 0.3), //30%
      300: Color.fromRGBO(217, 13, 125, 0.4), //40%
      400: Color.fromRGBO(217, 13, 125, 0.5), //50%
      500: Color.fromRGBO(217, 13, 125, 0.6), //60%
      600: Color.fromRGBO(217, 13, 125, 0.7), //70%
      700: Color.fromRGBO(217, 13, 125, 0.8), //80%
      800: Color.fromRGBO(217, 13, 125, 0.9), //90%
      900: Color.fromRGBO(217, 13, 125, 1), //100%
    },
  );
}

abstract class OneAssets {
  static const String splashAnimation = 'assets/lotties/animation_splash.json';
}

abstract class OneStyles {
  static const pageTitle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 32,
    color: OneColors.primaryDark,
  );
  static const subtitle = TextStyle(fontSize: 24, fontWeight: FontWeight.w300);
  static const cardinfo = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );
  static const body = TextStyle(fontSize: 16);
  static const description = TextStyle(fontSize: 11);
  static const hiperlink = TextStyle(
      fontSize: 16,
      decoration: TextDecoration.underline,
      color: OneColors.accentDark);

  static const fontFamilyPoppins = 'Poppins';
  static const titleStyle = TextStyle(
    color: OneColors.primaryDark,
    fontFamily: OneStyles.fontFamilyPoppins,
    fontSize: 25.0,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
  );
  static const subtitleStyle = TextStyle(
    fontFamily: OneStyles.fontFamilyPoppins,
    fontSize: 16.5,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
  );

  static const buttonStyle = TextStyle(
    fontFamily: OneStyles.fontFamilyPoppins,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );
}

abstract class OneSepators {
  static const verySmall = SizedBox(height: 4, width: 4);
  static const small = SizedBox(height: 8, width: 8);
  static const medium = SizedBox(height: 16, width: 16);
  static const big = SizedBox(height: 32, width: 32);
}
