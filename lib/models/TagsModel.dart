import 'dart:convert';

import 'package:flutter/widgets.dart';

TagsModel tagsModelFromJson(String str) => TagsModel.fromJson(json.decode(str));

String tagsModelToJson(TagsModel data) => json.encode(data.toJson());

class TagsModel {
  int id;
  String name;
  TagsModel({this.id, this.name});
  factory TagsModel.fromJson(Map<String, dynamic> json) => TagsModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
