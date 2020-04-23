import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zouqadmin/pages/dialogWorning.dart';

class AddProduct {
  final String apiUrl = "http://api.dhuqapp.com";
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
      if (listOfPhotos.length == something.length &&
          theVideo.length == videos.length) {
        print('hi from equals if');
        print('hi ^^ ' + video.toString());
        FormData _formData = video != null
            ? FormData.fromMap({
          "name": "$name",
          "description": "$desc",
          "price": "$price",
          "images": something,
          "video": theVideo[0],
          "category_id": catID.toString(),
        })
            : FormData.fromMap({
          "name": "$name",
          "description": "$desc",
          "price": "$price",
          "images": something,
          "category_id": catID.toString(),
        });
        try {
          // print('--------------------> addItemFile: ${_formData.files}');
          if (token.isNotEmpty) {
            print('before response');
            response =
            await Dio().post("http://api.dhuqapp.com/api/family/products",
                data: _formData,
                options: Options(
                  headers: {
                    HttpHeaders.authorizationHeader: "Bearer $token"
                  },
                ));
            print('after response');
            print(response.data);
          }
          if (response.statusCode == 200) {
            showDialog(
                context: context,
                builder: (BuildContext context) => DialogWorning(
                  mss: 'Product has been added successfully',
                ));
          } else {
            print(response.data);
            showDialog(
                context: context,
                builder: (BuildContext context) => DialogWorning(
                  mss:
                  'Something is wrong, please check your connection and try again ',
                ));
            return "something is wrong";
          }
        } on DioError catch (e) {
          print('Error ' + e.response.data);
          if (e.response == null) {
            showDialog(
                context: context,
                builder: (BuildContext context) => DialogWorning(
                  mss: 'connection time out ',
                ));
            return "connection time out";
          }
          showDialog(
              context: context,
              builder: (BuildContext context) => DialogWorning(
                mss:
                'Something is wrong, please check your connection and try again ',
              ));
          print(e.response.data);
        }
      }
      return null;
    });
    print('res ' + response.toString());
    return response;
  }
}
