// To parse this JSON data, do
//
//     final modelsListModel = modelsListModelFromJson(jsonString);

import 'dart:convert';

ModelsListModel modelsListModelFromJson(String str) =>
    ModelsListModel.fromJson(json.decode(str));

String modelsListModelToJson(ModelsListModel data) =>
    json.encode(data.toJson());

class ModelsListModel {
  bool status;
  int code;
  String message;
  List<DetailModel>? detailModel;

  ModelsListModel({
    required this.status,
    required this.code,
    required this.message,
    this.detailModel,
  });

  factory ModelsListModel.fromJson(Map<String, dynamic> json) {
    if (json["code"] == 200) {
      return ModelsListModel(
        status: json["status"],
        code: json["code"],
        message: json["message"],
        detailModel: List<DetailModel>.from(
            json["data"].map((x) => DetailModel.fromJson(x))),
      );
    } else {
      return ModelsListModel(
        status: json["status"],
        code: json["code"],
        message: json["message"],
      );
    }
  }

  Map<String, dynamic> toJson() {
    if (code == 200) {
      return {
        "status": status,
        "code": code,
        "message": message,
        "data": List<dynamic>.from(detailModel!.map((x) => x.toJson())),
      };
    } else {
      return {
        "status": status,
        "code": code,
        "message": message,
      };
    }
  }
}

class DetailModel {
  String id;
  String title;
  String name;
  String age;
  String height;
  String image;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  DetailModel({
    required this.id,
    required this.title,
    required this.name,
    required this.age,
    required this.height,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory DetailModel.fromJson(Map<String, dynamic> json) => DetailModel(
        id: json["_id"],
        title: json["title_earned"],
        name: json["name"],
        age: json["age"],
        height: json["height"],
        image: json["profile_pic"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "name": name,
        "age": age,
        "height": height,
        "image": image,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}
