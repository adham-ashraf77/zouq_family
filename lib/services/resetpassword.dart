import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:zouqadmin/ConstantVarables.dart';

class ResetPassword {
  final String _reset = "/api/family/send-reset-password-confirm-code";
  FormData _formData;

  Future<Response> resetPassword({@required String phone}) async {
    _formData = FormData.fromMap({"phone": "$phone"});
    Response response =
        await Dio().post('${ConstantVarable.baseUrl}$_reset', data: _formData);
    print('err' + response.toString());
    return response;
  }
}
