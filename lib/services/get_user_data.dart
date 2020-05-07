import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetUserData {
  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    Response response = await Dio().get("path");
  }
}
