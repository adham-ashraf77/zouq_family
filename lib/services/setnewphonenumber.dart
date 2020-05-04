import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetNewPhoneNumber {
  final String apiUrl = "https://api.dhuqapp.com";
  final String updatephone = "/api/family/update-phone";
  FormData _formData;

  Future<dynamic> setNewPhoneNumber(
      String phone) async {
        
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    print(phone);
    _formData = FormData.fromMap(
        {"phone": "$phone"});
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
