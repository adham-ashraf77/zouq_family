import 'dart:io';

import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zouqadmin/ConstantVarables.dart';

import 'getuser.dart';

class Login {
  final String _login = "/api/family/login";
  final String requestLogin = "/api/family/request-login";
  FormData _formData;
  static String lang = "";
  static int versionNumber = 2;
  var header = {'Version': '$versionNumber'};

  Future<int> signIn({String phone}) async {
    var data = {"phone": phone};
    Dio dio = new Dio();
    var res = await dio.post("${ConstantVarable.baseUrl}$requestLogin",
        data: data, options: Options(headers: header));
    return res.data['ttl'];
  }

  Future<dynamic> login({String phone, String otp}) async {
    print('-=>' + phone + otp);
    _formData = FormData.fromMap({"phone": "$phone", "confirm_code": otp});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      print(_formData.fields);
      Response response = await Dio().post("${ConstantVarable.baseUrl}$_login",
          data: _formData, options: Options(headers: header));

      /// `print("========= " + response.statusCode.toString() + " =========")`;
      print(response.data);

      ///
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        prefs.setString("phone", "$phone");
        prefs.setInt("id", response.data['user']['id']);
        prefs.setString("name", response.data['user']['name']);
        prefs.setString("token", response.data['token']);
        prefs.setString("image", response.data['image']);
        prefs.setString("email", response.data['email']);
        bool haveLocation;
        GetUser().getUser(token: response.data['token']).then((value) async {
          https: //github.com/saisantosh2095/flutter_apple_sign_in
          var x = value;
          print('X = ' + x['user'].toString());
          print(x['user']['latitude']);
          if (x['user']['latitude'] != null) {
            print('true *****************************');
            haveLocation = true;
          } else {
            print('false *****************************');
            haveLocation = false;
          }
          print(haveLocation);
          if (haveLocation == false) {
            print('hi from if');
            try {
              print('hi from try');
              Position position = await Geolocator()
                  .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
              await Dio().post(
                  '${ConstantVarable.baseUrl}/api/family/set-location',
                  data: {
                    "latitude": "${position.latitude}",
                    "longitude": "${position.longitude}",
                  },
                  options: Options(headers: {
                    HttpHeaders.authorizationHeader:
                    "Bearer ${response.data['token']}"
                  }));
            } on DioError catch (e) {
              print('error in get position');
              print(e.response.data);
            } catch (e) {
              print("no location");
            }
          }
        });

        return "success";
      } else {
        print('not a 200 request ${response.data}');
        return "something is wrong";
      }
    } on DioError catch (e) {
      print('err->' + e.response.toString());
      print(e.response.statusCode);
      if (e.response == null) return "connection time out";
      return e.response.data["message"];
    }
  }
}
