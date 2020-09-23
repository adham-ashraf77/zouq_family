import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zouqadmin/ConstantVarables.dart';

class PaginateOrders {
  final String _paginateOrder = '/api/family/orders?status=';

  Future<dynamic> paginateOrders({String status}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    Response response = await Dio()
        .get('${ConstantVarable.baseUrl}$_paginateOrder$status&limit=10000',
            options: Options(
              headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
            ));
    // print(response);
    return response;
  }
}
