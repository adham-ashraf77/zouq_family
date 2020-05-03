import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Delete {
  final String _url = "https://api.dhuqapp.com";
  final String _delete = '/api/family/products/';

  Future<dynamic> delete({@required String productID}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    Response response = await Dio()
        .delete('$_url$_delete$productID',
            options: Options(
              headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
            ))
        .catchError((onError) {
      print('delete_1' + onError.toString());
    });
    print('delete ' + response.toString());
    return response;
  }
}
