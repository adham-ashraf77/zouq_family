import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class GetUser {
  final String _url = "https://api.dhuqapp.com";
  final String _user = "/api/family/user";

  Future<dynamic> getUser({@required String token}) async {
    Response response = await Dio().get('$_url$_user',
        options: Options(
          headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
        ));
    print(response);
    return response;
  }
}
