import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaginateOrders {
  final String _url = "https://api.dhuqapp.com";
  final String _paginateOrder = '/api/family/orders?status=';


  Future<dynamic> paginateOrders({String status}) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    Response response = await Dio().get('$_url$_paginateOrder$status',
        options: Options(
          headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
        ));
    print(response);
    return response;
  }
}
