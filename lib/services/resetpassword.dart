
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class ResetPassword {
  final String _url = "https://api.dhuqapp.com";
  final String _reset = "/api/family/send-reset-password-confirm-code";
  FormData _formData;

  Future<Response> resetPassword({@required String phone}) async {
    _formData = FormData.fromMap({"phone": "$phone"});
    Response response = await Dio().post('$_url$_reset', data: _formData);
    print('err' + response.toString());
    return response;
  }
}
