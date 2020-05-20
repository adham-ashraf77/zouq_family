import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Paginate {
  final String _url = "https://api.dhuqapp.com";

  Future<dynamic> paginate({int category = 0, int page = 1, int limit = 10000}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    Response response = await Dio().get(
        '$_url' +
            '/api/family/categories/$category/products?page=$page&limit=$limit',
        options: Options(
          headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
        ));
    print(response);
    return response;
  }
}
