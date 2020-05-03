import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdatePhone {
  final String apiUrl = "https://api.dhuqapp.com";
  final String updatephone = "/api/family/send-update-phone-confirm-code";
  FormData _formData;

  Future<dynamic> updatePhone(
      String phone) async {
        
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    print(phone);
    try {
      Response response = await Dio().post("$apiUrl$updatephone",
          data: _formData,
          options: Options(
            headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
          ));
      print(response);
      return "success";
    } on DioError catch (e) {
      print(e.response);
      print(e.type);

      return e.response;
    }
  }
}
