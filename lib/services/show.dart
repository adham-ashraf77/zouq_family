import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Show {
  final String _url = "http://api.dhuqapp.com";
  final String _show = '/api/family/products/';

  Future<dynamic> show({@required String productID}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    Response response = await Dio()
        .get('$_url$_show$productID',
            options: Options(
              headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
            ))
        .catchError((onError) {
      print('Show_1' + onError.toString());
    });
    print('Show ' + response.toString());
    return response;
  }
}
