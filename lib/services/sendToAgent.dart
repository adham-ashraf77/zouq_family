import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zouqadmin/ConstantVarables.dart';

class IntroduceToAgents {
  String url = "http://api-testing.dhuqapp.com";
  String order = "/api/family/orders/";
  String introduceAgents = "/introduce-to-agents";

  Future introduceToAgents(String orderId) async {
    print(orderId);
    Response response;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    print("$url$order$orderId$introduceAgents");
    try {
      response = await Dio()
          .post("${ConstantVarable.baseUrl}$order$orderId$introduceAgents",
              options: Options(
                headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
              ));
      print('response of introduceToAgents class: $response');
    } on DioError catch (e) {
      print('error of introduceToAgents class: $e');
    }
  }
}
