import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:zouqadmin/ConstantVarables.dart';

class SetNewPassword {
  final String _reset = "/api/family/reset-password";
  FormData _formData;

  Future<Response> setNewPassword(
      {@required String phone, @required String newPassword}) async {
    _formData =
        FormData.fromMap({"phone": "$phone", "new-password": "$newPassword"});
    Response response = await Dio()
        .post('${ConstantVarable.baseUrl}$_reset', data: _formData)
        .catchError((onError) {
      print('Error ' + onError.toString());
    });
    return response;
  }
}
