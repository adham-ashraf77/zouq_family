import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zouqadmin/ConstantVarables.dart';

class Paginate {
  Future<dynamic> paginate(
      {int category = 0, int page = 1, int limit = 10000}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    Response response = await Dio().get(
        '${ConstantVarable.baseUrl}' +
            '/api/family/categories/$category/products?page=$page&limit=$limit',
        options: Options(
          headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
        ));
    print(response);
    return response;
  }
}
