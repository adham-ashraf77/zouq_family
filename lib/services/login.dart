import 'dart:io';

import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login {
  final String _url = "https://api.dhuqapp.com";
  final String _login = "/api/family/login";
  FormData _formData;

  Future<dynamic> login({String phone, String password}) async {
    print('-=>' + phone + password);
    _formData = FormData.fromMap({"password": "$password", "phone": "$phone"});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Response response = await Dio().post("$_url$_login", data: _formData);

      /// `print("========= " + response.statusCode.toString() + " =========")`;
      /// `print(response.data)`;
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        prefs.setString("password", "$password");
        prefs.setString("phone", "$phone");
        prefs.setString("token", response.data['token']);
        prefs.setString("image", response.data['image']);
        prefs.setString("email", response.data['email']);
       
        try {
           Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
          await Dio().post('$_url/api/family/set-location',
              data: {
                "latitude": "${position.latitude}",
                "longitude": "${position.longitude}",
              },
              options: Options(headers: {HttpHeaders.authorizationHeader: "Bearer ${response.data['token']}"}));
        } on DioError catch (e) {
          print('error in get position');
          print(e.response.data);
        }
        catch(e){
          print("no location");
        }
        return "success";
      } else {
        print('not a 200 request ${response.data}');
        return "something is wrong";
      }
    } on DioError catch (e) {
      print('err->' + e.response.toString());
      if (e.response == null) return "connection time out";
      return e.response;
    }
  }
}
