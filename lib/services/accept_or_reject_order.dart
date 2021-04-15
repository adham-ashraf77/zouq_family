import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zouqadmin/ConstantVarables.dart';

class AcceptOrRejectOrder {
  String url = "http://api-testing.dhuqapp.com";
  String order = "/api/family/orders/";
  FormData formData;

  Future postOrderStatus(
      {String orderId, String orderStatus, String orderTime}) async {
    /// orderStatus is only 2 values approve or reject
    print('orderId : $orderId');
    print('orderStatus : $orderStatus');
    print('url : "${ConstantVarable.baseUrl}$order$orderId/$orderStatus"');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.get("token");
    formData = FormData.fromMap({
      "duration": "$orderTime",
    });

    Response response;
    try {
      response = await Dio()
          .post("${ConstantVarable.baseUrl}$order$orderId/$orderStatus",
              data: formData,
              options: Options(
                headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
              ));
      print('from AcceptOrRejectOrder class Success: $response');
    } on DioError catch (e) {
      print('from AcceptOrRejectOrder class Error: ${e.response.data}');
    }
  }
}
