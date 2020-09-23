import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zouqadmin/ConstantVarables.dart';
import 'package:zouqadmin/pages/dialogWorning.dart';

import '../I10n/app_localizations.dart';

class UpdateProduct {
  final String addingProduct = "/api/family/products";
  FormData _formData;
  Response response;

  Future<dynamic> updateProduct(
      {String desc,
      String name,
      String price,
      List<int> tagsIdList,
      File video,
      List<File> listOfPhotos,
      int catID,
      @required String id,
      @required BuildContext context}) async {
    if (desc == null || desc.isEmpty || desc == '') {
      desc = '...';
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "";
    print('token: $token');
    List<MultipartFile> something = List();
    List<File> videos = List<File>();
    if (video != null) videos = [video];
    List<MultipartFile> theVideo = List();
    print('111');
    if (video != null)
      videos.forEach((video) async {
        theVideo.add(MultipartFile.fromFileSync("${video.path}"));
      });
    print('222');
    listOfPhotos.forEach((photo) async {
      something.add(MultipartFile.fromFileSync("${photo.path}"));
      print(listOfPhotos.length);
      print(something.length);
    });
    print('the video');
    print(theVideo.length);
    print('video');
    print(videos.length);
    if (listOfPhotos.length == something.length &&
        theVideo.length == videos.length) {
      print('hi ^^ ' + video.toString());

      FormData _formData = video != null
          ? FormData.fromMap({
              "name": "$name",
              "description": "$desc",
              "price": "$price",
              "images": something,
              "video": theVideo[0],
              "tags": tagsIdList,
              "category_id": catID.toString(),
            })
          : FormData.fromMap({
              "name": "$name",
              "description": "$desc",
              "price": "$price",
              "tags": tagsIdList,
              "images": something,
              "category_id": catID.toString(),
            });
      try {
        // print('--------------------> addItemFile: ${_formData.files}');
        if (token.isNotEmpty) {
          print('before response');
          response = await Dio()
              .post("${ConstantVarable.baseUrl}/api/family/products/$id",
                  data: _formData,
                  options: Options(
                    headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
                  ));
          print('after response');
          print(response.data);
        }
        print('a7ba b2aaaaaaaaaaaaaaa ${response.statusCode}');
        if (response.statusCode >= 200 && response.statusCode <= 299) {
          return 200;
        } else {
          return 400;
        }
      } on DioError catch (e) {
        print('error');
        print('Error ' + e.toString());
        if (e.response == null) {
          showDialog(
              context: context,
              builder: (BuildContext context) => DialogWorning(
                    mss: AppLocalizations.of(context).translate('failed'),
                  ));
          return "connection time out";
        }
        showDialog(
            context: context,
            builder: (BuildContext context) => DialogWorning(
                  mss: AppLocalizations.of(context).translate('failed'),
                ));
        print(e.response.data);
      }
    }
    return null;
    print('res ' + response.toString());
    return response;
  }
}
