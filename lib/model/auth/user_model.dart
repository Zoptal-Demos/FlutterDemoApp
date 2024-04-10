// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  bool status;
  int code;
  String message;
  String? token;
  UserDetail? userDetail;

  UserModel({
    required this.status,
    required this.code,
    required this.message,
     this.token,
     this.userDetail,
  });

  factory UserModel.fromJson(Map<String, dynamic> json)  {
    if(json["code"]==200){
      return UserModel(
        status: json["status"],
        code: json["code"],
        message: json["message"],
        token: json["token"],
        userDetail: UserDetail.fromJson(json["data"]),
      );
    }else{
      return UserModel(
        status: json["status"],
        code: json["code"],
        message: json["message"],
        token: json["token"],
      );
    }
  }

  Map<String, dynamic> toJson()  {
    if(code==200){
      return {
        "status": status,
        "code": code,
        "message": message,
        "token": token,
        "data": userDetail!.toJson(),
      };
    }else{
      return {
        "status": status,
        "code": code,
        "message": message,
        "token": token,
      };
    }
  }
}

class UserDetail {
  String id;
  String userName;
  String userEmail;
  String password;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  UserDetail({
    required this.id,
    required this.userName,
    required this.userEmail,
    required this.password,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
    id: json["_id"],
    userName: json["user_name"],
    userEmail: json["user_email"],
    password: json["password"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user_name": userName,
    "user_email": userEmail,
    "password": password,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}
