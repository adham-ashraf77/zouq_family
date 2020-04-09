import 'package:flutter/material.dart';

///////////////////////////////////////////////////////////
/// Colors
///////////////////////////////////////////////////////////

Color mainColor = Colors.white;
Color accent = Colors.cyan;
Color splash = Colors.blue;
Color textColor = Color(0xFF303030);
Color smallTextColor = Color(0xFF929292);
Color iconsFaded = Colors.grey[400];
Color iconColors2 = Color(0xFFF96D7E);
Color inputBackgrounds = Colors.grey[300];

//order type chips colors

Color doneColor = Color(0xFF48CF84);
Color rejectedColor = Color(0xFFF96D7E);
Color confirmedColor = Color(0xFFF39D67);
Color confirmedBgColor = Color(0xFFF6EDE7);

///////////////////////////////////////////////////////////
/// Text Styles
///////////////////////////////////////////////////////////

TextStyle headers =
    TextStyle(color: textColor, fontWeight: FontWeight.w700, fontSize: 45);
TextStyle headers1 =
    TextStyle(color: textColor, fontWeight: FontWeight.w400, fontSize: 35);
TextStyle headers1bold =
    TextStyle(color: textColor, fontWeight: FontWeight.w700, fontSize: 35);
TextStyle headers2 =
    TextStyle(color: textColor, fontWeight: FontWeight.w300, fontSize: 30);
TextStyle headers3 =
    TextStyle(color: textColor, fontWeight: FontWeight.w300, fontSize: 25);
TextStyle headers4 = TextStyle(
    color: textColor,
    fontWeight: FontWeight.bold,
    fontSize: 20,
    fontFamily: "Dubai");

TextStyle accentColorHeader = TextStyle(
  color: accent,
  fontSize: 30,
  fontWeight: FontWeight.bold,
);

TextStyle paragarphBold = TextStyle(color: textColor, fontSize: 30);
TextStyle paragarphBold1 = TextStyle(color: textColor, fontSize: 25);
TextStyle paragarphBold2 = TextStyle(color: textColor, fontSize: 15);

TextStyle paragarph = TextStyle(color: smallTextColor, fontSize: 30);
TextStyle paragarph1 = TextStyle(color: smallTextColor, fontSize: 22);
TextStyle paragarph2 = TextStyle(color: smallTextColor, fontSize: 18);
TextStyle paragarph3 = TextStyle(color: smallTextColor, fontSize: 15);
TextStyle paragarph4 = TextStyle(color: smallTextColor, fontSize: 15);
TextStyle paragarph5 = TextStyle(color: textColor, fontSize: 18, height: 1);
TextStyle paragarph6 =
    TextStyle(color: smallTextColor, fontSize: 18, height: 1);

TextStyle productName = TextStyle(color: textColor, fontSize: 25);
TextStyle productName1 = TextStyle(color: textColor, fontSize: 20);
TextStyle productName2 = TextStyle(color: textColor, fontSize: 18);
TextStyle productName3 = TextStyle(color: textColor, fontSize: 15);

TextStyle buttonStyleMain = TextStyle(color: mainColor, fontSize: 20);
TextStyle buttonStyleAccent = TextStyle(color: accent, fontSize: 20);

TextStyle priceText = TextStyle(color: accent, fontSize: 25);
TextStyle priceText1 = TextStyle(
  color: accent,
  fontSize: 13,
);

TextStyle moreTextStyle = TextStyle(
    color: Color(0xFF4D4D4D),
    fontSize: 20,
    fontFamily: 'Dubai',
    fontWeight: FontWeight.w700);
TextStyle moreTextStyle1 = TextStyle(
    color: Color(0xFF4D4D4D),
    fontSize: 18,
    fontFamily: 'Dubai',
    fontWeight: FontWeight.w700);
TextStyle moreSmallTextStyle = TextStyle(
    color: Color(0xFF929292),
    fontSize: 15,
    fontFamily: 'Dubai',
    fontWeight: FontWeight.w700);

TextStyle hintTextStyle = TextStyle(
    color: Color(0xFF636363),
    fontSize: 18.0,
    fontFamily: 'Dubai',
    fontWeight: FontWeight.w500);

///////////////////////////////////////////////////////////
/// theme
///////////////////////////////////////////////////////////

ThemeData appTheme = ThemeData(
    appBarTheme: appBarTheme, brightness: appBrightness, fontFamily: "Dubai");

Brightness appBrightness = Brightness.light;

AppBarTheme appBarTheme = AppBarTheme(
  color: mainColor,
  iconTheme: IconThemeData(color: accent),
  elevation: 0.0,
);

///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
/// Default Images assets links
///////////////////////////////////////////////////////////
String assetsImageBasePath = "assets/images";

String profileImg = '$assetsImageBasePath/profilePlaceHolder.png';