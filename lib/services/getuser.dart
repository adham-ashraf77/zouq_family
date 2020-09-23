import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:zouqadmin/ConstantVarables.dart';

class GetUser {
  final String _user = "/api/family/user";

  Future<dynamic> getUser({@required String token}) async {
    Response response = await Dio().get('${ConstantVarable.baseUrl}$_user',
        options: Options(
          headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
        ));
    print(response.data);
    return response.data;
  }
}
