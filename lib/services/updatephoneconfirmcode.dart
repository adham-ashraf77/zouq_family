import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zouqadmin/ConstantVarables.dart';

class UpdatePhoneConfirmCode {
  final String confirmCode = "/api/family/check-update-phone-confirm-code";
  FormData _formData;

  Future<dynamic> updatePhoneConfirmCode(String code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    _formData = FormData.fromMap({"confirm_code": "$code"});

    print(code);
    try {
      Response response =
          await Dio().post("${ConstantVarable.baseUrl}$confirmCode",
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
