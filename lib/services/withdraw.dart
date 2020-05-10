import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Withdraw {
  final String _url = "https://api.dhuqapp.com";
  final String _withdraw = "/api/family/submit-withdrawal-request";

  withdrawMoney({int iban, String bankName, double quantity}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    Response _response;
    FormData _formData;
    _formData = FormData.fromMap({
      "iban": "$iban",
      "quantity": "$quantity",
      "bank_name": "$bankName",
    });
    try {
      _response = await Dio().post("$_url$_withdraw",
          data: _formData,
          options: Options(
            headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
          ));
      print("response: ${_response.data}");
    } on DioError catch (e) {
      print("error in withdraw class : ${e.response.data}");
    }
  }
}
