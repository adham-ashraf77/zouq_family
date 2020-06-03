import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class UserLanguage {
  final String _url = "https://api.dhuqapp.com";
  final String _userLang = "/api/family/set-lang";
  FormData _formData;

  Future<dynamic> setLang({@required String token, String lang}) async {
    _formData = FormData.fromMap({"lang": "$lang"});
    Response response = await Dio().post('$_url$_userLang',
        data: _formData,
        options: Options(
          headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
        ));
    return response;
  }
}
