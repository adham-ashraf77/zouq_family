import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zouqadmin/ConstantVarables.dart';

class UpdateProfile {
  final String apiUrl = "http://api.dhuqapp.com";
  final String updateprof = "/api/family/update-profile";
  FormData _formData;

  Future<dynamic> updateProfile(
      {String desc,
      String ida,
      String newPassword,
      File image,
      String openingFrom,
      String openingTo,
      int cityID}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    newPassword.isEmpty == true && image == null ||
            image.path.isEmpty ||
            image.path == ''
        ? _formData = FormData.fromMap({
            "description": '$desc',
            'is_delivery_available': '$ida',
            "opening_from": "$openingFrom",
            "opening_to": "$openingTo",
            "city_id": "$cityID"
            // 'password' : '$newPassword',
          })
        : image.path.isNotEmpty
            ? _formData = FormData.fromMap({
                "description": '$desc',
                'is_delivery_available': '$ida',
                'image': await MultipartFile.fromFile(image.path),
                "opening_from": "$openingFrom",
                "opening_to": "$openingTo",
                "city_id": "$cityID"
                // 'password' : '$newPassword',
              })
            : _formData = FormData.fromMap({
                "description": '$desc',
                'is_delivery_available': '$ida',
                'password': '$newPassword',
                "opening_from": "$openingFrom",
                "opening_to": "$openingTo",
                "city_id": "$cityID"
              });
    try {
      Response response =
          await Dio().post("${ConstantVarable.baseUrl}$updateprof",
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
