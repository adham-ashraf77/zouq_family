import 'package:dio/dio.dart';
import 'package:zouqadmin/ConstantVarables.dart';
import 'package:zouqadmin/models/categories.dart';
import 'package:zouqadmin/models/cities.dart';

class GetData {
  String _categories = "/api/content/categories";
  String _cities = "/api/content/cities";

  static List<Categories> arCategories = [];
  static List<Categories> enCategories = [];
  static List<Cities> arCity = [];
  static List<Cities> enCity = [];

  Future<void> getCategories() async {
    try {
      Response response =
          await Dio().get("${ConstantVarable.baseUrl}$_categories");
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        List<dynamic> data = response.data;
        for (int i = 0; i < data.length; i++) {
          arCategories
              .add(Categories(id: data[i]["id"], text: data[i]["text_ar"]));
          enCategories
              .add(Categories(id: data[i]["id"], text: data[i]["text_en"]));
        }
        print("success");
      } else {
        print('not a 200 requesy ${response.data}');
      }
    } on DioError catch (e) {
      print(e.response);
    }
  }

  Future<void> getCity() async {
    try {
      Response response = await Dio().get("${ConstantVarable.baseUrl}$_cities");
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        List<dynamic> data = response.data;
        for (int i = 0; i < data.length; i++) {
          arCity.add(Cities(id: data[i]["id"], text: data[i]["text_ar"]));
          enCity.add(Cities(id: data[i]["id"], text: data[i]["text_en"]));
        }
        print("success");
      } else {
        print('not a 200 requesy ${response.data}');
      }
    } on DioError catch (e) {
      print(e.response);
    }
  }
}
