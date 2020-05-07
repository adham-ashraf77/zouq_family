import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AcceptOrRejectOrder {
  String url = "https://api.dhuqapp.com";
  String order = "/api/family/orders/";

  void postOrderStatus({String orderId, String orderStatus}) async {
    /// orderStatus is only 2 values approve or reject
    print('orderId : $orderId');
    print('orderStatus : $orderStatus');
    print('url : "$url$order$orderId/$orderStatus"');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.get("token");

    Response response;
    try {
      response = await Dio().post("$url$order$orderId/$orderStatus",
          options: Options(
            headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
          ));
      print('from AcceptOrRejectOrder class Success: $response');
    } on DioError catch (e) {
      print('from AcceptOrRejectOrder class Error: ${e.response.data}');
    }
  }
}
