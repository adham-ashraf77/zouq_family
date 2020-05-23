import 'package:dio/dio.dart';

class NetworkHelper {
  getFAQ() async {
    try {
      Response response = await Dio().get('http://api.dhuqapp.com/api/content/questions-and-answers');
      var data = response.data;
      return data;
    } catch (e) {
      print(e);
    }
  }

  getTerms() async {
    try {
      Response response = await Dio().get('http://api.dhuqapp.com/api/content/page/terms-and-conditions');
      var data = response.data;
      return data;
    } catch (e) {
      print(e);
    }
  }

  getEULA() async {
    try {
      Response response = await Dio().get('http://api.dhuqapp.com/api/content/page/usage-policy');
      var data = response.data;
      return data;
    } catch (e) {
      print(e);
    }
  }

  getContactInfo() async {
    try {
      Response response = await Dio().get('http://api.dhuqapp.com/api/content/contact-info');
      var data = response.data;
      print('zoooooooooooooooooouq data=====> ${response.data}');
      return data;
    } catch (e) {
      print(e);
    }
  }

  getSocialMedia() async {
    try {
      Response response = await Dio().get('http://api.dhuqapp.com/api/content/social-links');
      var data = response.data;
      return data;
    } catch (e) {
      print(e);
    }
  }
}
