import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zouqadmin/ConstantVarables.dart';

class EndOrder {
  String url = "https://api.dhuqapp.com";
  String order = "/api/family/orders/";
  String finish = "/finish";

  Future endOrder(String orderId) async {
    print(orderId);
    Response response;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    try {
      response =
          await Dio().post("${ConstantVarable.baseUrl}$order$orderId$finish",
              options: Options(
                headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
              ));
      print('response of EndOrder class: $response');
    } on DioError catch (e) {
      print('error of EndOrder class: $e');
    }
  }
}
