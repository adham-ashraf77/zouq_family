import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zouqadmin/ConstantVarables.dart';

class Delete {
  final String _url = "http://api.dhuqapp.com";
  final String _delete = '/api/family/products/';

  Future<dynamic> delete({@required String productID}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    Response response;
    try {
      response =
          await Dio().delete('${ConstantVarable.baseUrl}$_delete$productID',
              options: Options(
                headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
              ));
    } on DioError catch (e) {
      print(e.response.data);
      print(e.response.data['message']);
      return e.response.data['message'];
    }
    print('delete ' + response.toString());
    return response;
  }
}
