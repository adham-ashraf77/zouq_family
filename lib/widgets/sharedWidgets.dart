import 'package:flutter/material.dart';
import 'package:zouqadmin/theme/common.dart';

///////////////////////////////////////////////////////////
/// Global Widgets
///////////////////////////////////////////////////////////

//Input Fileds

Widget customInputFiled(
    {String hintText = "", IconData icon = Icons.lens, bool obsured = false}) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: TextField(
      textAlign: TextAlign.end,
      textDirection: TextDirection.rtl,
      obscureText: obsured,
      decoration: InputDecoration(
        suffixIcon: Image.asset("assets/icons/search.png"),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: accent, width: 3.0),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: inputBackgrounds, width: 3.0),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        fillColor: inputBackgrounds,
        filled: true,
        contentPadding: EdgeInsets.only(
          top: 10,
          bottom: 10,
          right: 15,
          left: 15,
        ),
        hintText: '$hintText',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    ),
  );
}

Widget customTextArea({String hintText = ""}) {
  return TextField(
      maxLines: 4,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        hintText: hintText,
        fillColor: inputBackgrounds,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: accent, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: inputBackgrounds, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ));
}

Widget materialInputField(
    {String hintText = "",
    String prefixText,
    bool isPassword = false,
    String label = ""}) {
  return TextFormField(
    style: paragarph2,
    obscureText: isPassword,
    maxLines: 1,
    textAlign: TextAlign.right,
    decoration: InputDecoration(
      labelText: "$label",
      prefixText: prefixText,
      focusColor: accent,
      hoverColor: Colors.grey,
      hintText: hintText,
    ),
  );
}
