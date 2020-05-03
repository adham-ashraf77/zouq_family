import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProfile {
  final String apiUrl = "https://api.dhuqapp.com";
  final String updateprof = "/api/family/update-profile";
  FormData _formData;

  Future<dynamic> updateProfile(String desc, String ida,String newPassword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    _formData = FormData.fromMap({
      "description": '$desc',
      'is_delivery_available': '$ida',
      'password' : '$newPassword',
    });
    try {
      Response response = await Dio().post("$apiUrl$updateprof",
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
