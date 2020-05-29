import 'package:dio/dio.dart';
import 'package:zouqadmin/models/CategoriesTag.dart';

class GetCategories {
  String _url = "https://api.dhuqapp.com";
  String _categories = "/api/content/categories";
  static List<CategoriesTag> categories = [];

  Future<void> getCategories() async {
    categories = [];
    try {
      Response response = await Dio().get("$_url$_categories");
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa ${response.data}');
        List<dynamic> data = response.data;
        for (int i = 0; i < data.length; i++) {
          categories.add(CategoriesTag(id: data[i]["id"], text_ar: data[i]["text_ar"], text_en: data[i]["text_en"]));
        }
        print("success");
      } else {
        print('not a 200 requesy ${response.data}');
      }
    } on DioError catch (e) {
      print('errooooooooooooor');
      print(e);
    }
  }
}
