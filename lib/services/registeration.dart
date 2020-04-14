import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Registeration {
  final String _url = "http://api.dhuqapp.com";
  final String _registeraAndSendConfirm =
      "/api/family/register-and-send-confirm-code";
  final String _resendRegisterConfirmCode =
      "/api/family/resend-register-confirm-code";
  final String _activateRegisteredUser = "/api/family/activate-registered-user";
  final String _currentUser = "/api/family/user";
  FormData _formData;

  Future<String> registration(
      {String name,
      String gender,
      String phone,
      String password,
      String email,
      bool is_delivery_available,
      File image,
      List<String> categories,
      String city}) async {
    _formData = FormData.fromMap({
      "name": "$name",
      "gender": "$gender",
      "password": "$password",
      "email": "$email",
      "phone": "$phone",
      "is_delivery_available": "$is_delivery_available",
      "image": "$image",
      "categories": "$categories",
      "city": "$city",
    });
    try {
      Response response =
          await Dio().post("$_url$_registeraAndSendConfirm", data: _formData);
      print(response.data);
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        return "success";
      } else {
        print('not a 200 requesy ${response.data}');
        return "something is wrong";
      }
    } on DioError catch (e) {
      print(e.response);
      if (e.response.data["errors"]["email"].toString() ==
          "[The email has already been taken.]") {
        return "The email has already been taken.";
      }
      if (e.response.data["errors"]["phone"].toString() ==
          "[The phone has already been taken.]") {
        return "The phone has already been taken.";
      }
      if (e.response == null) return "connection time out";
    }
    return "Worning check the Data";
  }

  Future<String> resendConfirmCode(String phone) async {
    _formData = FormData.fromMap({"phone": "$phone"});
    try {
      Response response =
          await Dio().post("$_url$_resendRegisterConfirmCode", data: _formData);
      print(response.data);
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        return "success";
      } else {
        print('not a 200 requesy ${response.data}');
        return "something is wrong";
      }
    } on DioError catch (e) {
      print(e.response);
      if (e.response == null) return "connection time out";
      if (e.response.data["message"] ==
          "there is no inactive user have this phone number")
        return "there is no inactive user have this phone number";
    }
    return "Worning check the mobile number";
  }

  Future<String> activateRegistered(String phone, String code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _formData = FormData.fromMap({"phone": "$phone", "confirm_code": "$code"});
    try {
      Response response =
          await Dio().post("$_url$_activateRegisteredUser", data: _formData);
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        Map data = response.data;
        Response response2 = await Dio().get("$_url$_currentUser",options: Options(
          headers: {HttpHeaders.authorizationHeader:"Bearer ${data['token']}"}
        ));
        Map data2 = response2.data;
        print(data2);
        //TODO save data in SharedPreferences
//        prefs.setString("token", "${data['token']}");
//        prefs.setString("id", "${data['user']['id']}");
//        prefs.setString("name", "${data['user']['name']}");
//        prefs.setString("email", "${data['user']['email']}");
//        prefs.setString("phone", "${data['user']['phone']}");
//        prefs.setString("avatar", "${data['user']['avatar']}");
//        prefs.setString("latitude", "${data['user']['latitude']}");
//        prefs.setString("longitude", "${data['user']['longitude']}");
//        prefs.setString("city", "${data['user']['city']}");
//        prefs.setString("gender", "${data['user']['gender']}");
//        prefs.setString("pocket", "${data['user']['pocket']}");
        return "success";
      } else {
        print('not a 200 requesy ${response.data}');
        return "something is wrong";
      }
    } on DioError catch (e) {
      print(e.response);
      if (e.response.data["message"] ==
          "there is no inactive user have this phone number") {
        return "there is no inactive user have this phone number";
      }
      if (e.response == null) return "connection time out";
    }
    return "confirm code is not valid";
  }
}
