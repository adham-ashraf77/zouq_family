import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zouqadmin/pages/dialogWorning.dart';

import '../I10n/app_localizations.dart';

class AddProduct {
  final String apiUrl = "https://api.dhuqapp.com";
  final String addingProduct = "/api/family/products";
  FormData _formData;
  Response response;

  Future<dynamic> addProduct(
      {String desc,
      String name,
      String price,
      File video,
      List<File> listOfPhotos,
      int catID,
      @required BuildContext context}) async {
    FormData formData;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "";
    print('token: $token');
    List<MultipartFile> something = List();
    List<File> videos = List<File>();
    List<MultipartFile> theVideo = List();
    print('111');
    if (video != null) {
      videos = [video];
      videos.forEach((video) async {
        theVideo.add(MultipartFile.fromFileSync("${video.path}"));
      });
    }
    print('222');
    print(listOfPhotos.length);
    listOfPhotos.forEach((photo) async {
      something.add(MultipartFile.fromFileSync("${photo.path}"));
      print(listOfPhotos.length);
      print(something.length);
      print('the video length: ${theVideo.length}');
      print('the lenthght of  normal video ${videos.length}');
    });
    if (listOfPhotos.length == something.length && theVideo.length == videos.length) {
      print('hi from equals if');
      // print('hi ^^ ' + video.toString());
      print('At API call: catID=> $catID');
      print('At API call: desc=> $desc');
      print('At API call: name=> $name');
      something.forEach((element) {
        print('before API call: listOfPhotos=> ${element.filename}');
      });
      print('At API call: price=> $price');
      print('At API call: video=> ${theVideo[0].filename}');
      if (video == null || video.path.isEmpty == true) {
        formData = FormData.fromMap({
          "name": "$name",
          "description": "$desc",
          "price": "$price",
          "images": something,
          "category_id": catID.toString(),
        });
      } else {
        formData = FormData.fromMap({
          "name": "$name",
          "description": "$desc",
          "price": "$price",
          "images": something,
          "video": theVideo[0],
          "category_id": catID.toString(),
        });
      }
//      FormData _formData = video != null
//          ? FormData.fromMap({
//        "name": "$name",
//        "description": "$desc",
//        "price": "$price",
//        "images": something,
//        "video": theVideo[0],
//        "category_id": catID.toString(),
//      })
//          : FormData.fromMap({
//        "name": "$name",
//        "description": "$desc",
//        "price": "$price",
//        "images": something,
//        "category_id": catID.toString(),
//      });
      try {
        // print('--------------------> addItemFile: ${_formData.files}');
        if (token.isNotEmpty) {
          print('before response');
          response = await Dio().post("http://api.dhuqapp.com/api/family/products",
              data: formData,
              options: Options(
                headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
              ));
          print('after response');
          print(response.data);
        }
        if (response.statusCode == 200) {
          showDialog(
              context: context,
              builder: (BuildContext context) => DialogWorning(
                mss: AppLocalizations.of(context).translate('success'),
              ));
        } else {
          print(response.data);
          showDialog(
              context: context,
              builder: (BuildContext context) => DialogWorning(
                mss: AppLocalizations.of(context).translate('failed'),
              ));
          return "something is wrong";
        }
      } on DioError catch (e) {
        print('Error ' + '${e}');
        if (e.response == null) {
          showDialog(
              context: context,
              builder: (BuildContext context) => DialogWorning(
                mss: AppLocalizations.of(context).translate('failed'),
              ));
          return AppLocalizations.of(context).translate('failed');
        }
        showDialog(
            context: context,
            builder: (BuildContext context) => DialogWorning(
              mss: AppLocalizations.of(context).translate('failed'),
            ));
        print(e.response.data);
      }
    }
    print('res ' + response.toString());
    return response;
  }
}
