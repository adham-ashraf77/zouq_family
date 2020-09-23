import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zouqadmin/ConstantVarables.dart';

class GetOrderWithProducts {
  final String _url = "https://api.dhuqapp.com";
  final String _order = "/api/family/orders/";

  Future<dynamic> getOrderWithProducts({@required id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    Response response = await Dio().get('${ConstantVarable.baseUrl}$_order$id',
        options: Options(
          headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
        ));
    // print(response);
    return response;
  }
}
