import 'package:dio/dio.dart';
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
