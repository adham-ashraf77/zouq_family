import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:zouqadmin/ConstantVarables.dart';

class CheckPasswordResettingCode {
  final String _url = "http://api.dhuqapp.com";
  final String _reset = "/api/family/check-reset-password-confirm-code";
  FormData _formData;

  Future<Response> resetPassword(
      {@required String phone, @required String code}) async {
    print(phone + ' = ' + code);
    _formData = FormData.fromMap({"phone": "$phone", "confirm_code": "$code"});
    Response response =
        await Dio().post('${ConstantVarable.baseUrl}$_reset', data: _formData);
    return response;
  }
}
