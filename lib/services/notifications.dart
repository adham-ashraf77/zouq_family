import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zouqadmin/ConstantVarables.dart';
import 'package:zouqadmin/models/notificationContent.dart';

class Notifications {
  final String _sendFcmToken = "/api/family/set-device-id";
  final String _notificationList = "/api/notifications?page=1&limit=900";
  FormData _formData;

  sendFcmToken({String fcmToken}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.get("token");
    _formData = FormData.fromMap({"device_id": fcmToken});
    try {
      Response response = await Dio().post(
          "${ConstantVarable.baseUrl}$_sendFcmToken",
          data: _formData,
          options: Options(
              headers: {HttpHeaders.authorizationHeader: "Bearer $token"}));
      print(response.data);
    } on DioError catch (e) {
      print('err => ' + '${e.response.data}');
    }
  }

  Future<List<NotificationsContent>> getNotificationsList() async {
    List<NotificationsContent> list = new List();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.get("token");
    Response response = await Dio().get(
        "${ConstantVarable.baseUrl}$_notificationList",
        options: Options(
            headers: {HttpHeaders.authorizationHeader: "Bearer $token"}));
    print(response.data);
    var data = response.data;
    data['notifications'].forEach((value) {
      list.add(NotificationsContent.fromApi(value));
    });
    return list;
  }
}
