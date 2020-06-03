import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Registeration {
  final String _url = "https://api.dhuqapp.com";
  final String _registeraAndSendConfirm =
      "/api/family/register-and-send-confirm-code";
  final String _resendRegisterConfirmCode =
      "/api/family/resend-register-confirm-code";
  final String _activateRegisteredUser = "/api/family/activate-registered-user";
  final String _currentUser = "/api/family/user";
  FormData _formData;

  Future<String> registration({
    String shopName,
    String shopOwnerName,
    String pIN,
    String phone,
    String password,
    String email,
    bool is_delivery_available,
    File image,
    List<int> categories,
    int city,
  }) async {
    String fileName = image.path.split('/').last;
    _formData = FormData.fromMap({
      "name": "$shopName",
      "manager_name": "$shopOwnerName",
      "identity_number": "$pIN",
      "password": "$password",
      "email": "$email",
      "phone": "$phone",
      "is_delivery_available": is_delivery_available ? 1 : 0,
      "image": await MultipartFile.fromFile(image.path, filename: fileName),
      "categories": categories,
      "city": city,
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
      if (e.response.data["errors"]['phone'] != null) {
        return "phoneError";
      } else if (e.response.data["errors"]['email'] != null) {
        return "emailError";
      }
      print(e.response);
      return e.response.data['message'];
    }
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
//        Map data = response.data;
//        print(data['token']);
//        Response response2 = await Dio().get("$_url$_currentUser",
//            options: Options(headers: {HttpHeaders.authorizationHeader: "Bearer ${data['token']}"}));
//        Map data2 = response2.data;
//        print(data2);
//        //TODO save data in SharedPreferences
//        prefs.setString("token", "${data['token']}");
//        prefs.setString("id", "${data2['user']['id']}");
//        prefs.setString("name", "${data2['user']['name']}");
//        prefs.setString("email", "${data2['user']['email']}");
//        prefs.setString("phone", "${data2['user']['phone']}");
//        prefs.setString("avatar", "${data2['user']['avatar']}");
//        prefs.setString("cityId", "${data2['user']['city']['id']}");
//        prefs.setString("cityTextAr", "${data2['user']['city']['text_ar']}");
//        prefs.setString("cityTextEn", "${data2['user']['city']['text_en']}");
//        prefs.setString("latitude", "${data2['user']['latitude']}");
//        prefs.setString("longitude", "${data2['user']['longitude']}");
//        prefs.setString("description", "${data2['user']['description']}");
//        prefs.setString("is_delivery_available", "${data2['user']['is_delivery_available']}");
//        Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//        try {
//          Response response = await Dio().post('$_url/api/family/set-location',
//              data: {
//                "latitude": "${position.latitude}",
//                "longitude": "${position.longitude}",
//              },
//              options: Options(headers: {HttpHeaders.authorizationHeader: "Bearer ${data['token']}"}));
//        } on DioError catch (e) {
//          print('error in get position');
//          print(e.response.data);
//        }
        return "success";
      } else {
        print('not a 200 requesy ${response.data}');
        return "something is wrong";
      }
    } on DioError catch (e) {
      print('naniiiiiiiiiiiiiiiiiiii');
      print(e.response);
      if (e.response.data["message"] == "there is no inactive user have this phone number") {
        return "there is no inactive user have this phone number";
      }
      if (e.response == null) return "connection time out";
    }
    return "confirm code is not valid";
  }
}
